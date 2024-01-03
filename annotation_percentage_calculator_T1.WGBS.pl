use strict;
use warnings;
use Data::Dumper;
use List::Util qw(min max);
use Text::Table;

print "Make sure to Sort by chr,start,annot.chr,annot.start; this is essential or else calculationw ill be wrong\n";
print "Make sure to fixing excel sorting chr10/2 issue\n";


my $filename = $ARGV[0];
open IN, $filename or die;
my @input_db = <IN>;

my $extracted_filename;
if ($filename =~ /(.+)\.txt$/) {
    $extracted_filename = $1;
    print "Extracted filename: $extracted_filename\n";
} else {
    print "No filename with '.txt' extension found.\n";
}

open OUT, ">${extracted_filename}.OUTPUT.txt";


# Create a hash table to initialize the annotation types are their proportion
my %final_percentage_db;
foreach my $l (@input_db)
    {
        chomp $l;
        next if $l =~ /^rownum/;
        my @arr = split("\t", $l);
        my $wgbs_coordinates = $arr[5];
        $final_percentage_db{$wgbs_coordinates}{"hg38_cpg_inter"} = 0;
        $final_percentage_db{$wgbs_coordinates}{"hg38_cpg_islands"} = 0;
        $final_percentage_db{$wgbs_coordinates}{"hg38_cpg_shelves"} = 0;
        $final_percentage_db{$wgbs_coordinates}{"hg38_cpg_shores"} = 0;
    }

# Create a hash table to count the DMRs which are splitted into difference CpGannotations
my %DMR_CPGregion_counter;
foreach my $l (@input_db)
    {
        chomp $l;
        next if $l =~ /^rownum/;
        my @arr = split("\t", $l);
        my $wgbs_coordinates = $arr[5];
        if (exists($DMR_CPGregion_counter{$wgbs_coordinates}))
            {
                $DMR_CPGregion_counter{$wgbs_coordinates} = $DMR_CPGregion_counter{$wgbs_coordinates} + 1;
            }
        else 
            {
                $DMR_CPGregion_counter{$wgbs_coordinates} = 1;
            }
        
    }

# Create a hash table to store annotation type with coorediantes for each DMR regions
my %DMR_annotationType_db;
foreach my $l (@input_db)
    {
        chomp $l;
        next if $l =~ /^rownum/;
        my @arr = split("\t", $l);
        my $wgbs_coordinates = $arr[5];
        my $number_of_regions = $DMR_CPGregion_counter{$wgbs_coordinates};
        my $counter = 0;
        if ($number_of_regions > 1)
            {
                my $annot_coordinates = $arr[6].":".$arr[7]."-".$arr[8];
                my $annot_type = $arr[11];
                $annot_type =~ s/\n|\r//g;
                while($counter <= $number_of_regions)
                    {
                        $DMR_annotationType_db{$wgbs_coordinates}{$annot_coordinates}{"chr"} = $arr[6];
                        $DMR_annotationType_db{$wgbs_coordinates}{$annot_coordinates}{"start"} = $arr[7];
                        $DMR_annotationType_db{$wgbs_coordinates}{$annot_coordinates}{"end"} = $arr[8];
                        $DMR_annotationType_db{$wgbs_coordinates}{$annot_coordinates}{"type"} = $annot_type;
                        $counter++;
                    }
            }

    }

# Process each line to account for proportion of single regions
foreach my $l (@input_db)
    {
        chomp $l;
        next if $l =~ /^rownum/;
        my @arr = split("\t", $l);
        my $wgbs_coordinates = $arr[5];
        my $number_of_regions = $DMR_CPGregion_counter{$wgbs_coordinates};
        if ($number_of_regions == 1)
            {
                # print OUT  "LESS:\t$wgbs_coordinates\t$number_of_regions\n";
                my $annot_type = $arr[11];
                $annot_type =~ s/\n|\r//g;
                $final_percentage_db{$wgbs_coordinates}{$annot_type} = 1;
            }

    }

# Now calculate proportion of annotation from the %DMR_annotationType_db. This will make this less complicated.
foreach my $wgbs_coordinates (sort keys %DMR_annotationType_db)
    {
        my @to_Analyze;
        foreach my $annot_coordinates (sort keys %{$DMR_annotationType_db{$wgbs_coordinates}})
            {
                my $annotChr = $DMR_annotationType_db{$wgbs_coordinates}{$annot_coordinates}{"chr"};
                my $annotStart = $DMR_annotationType_db{$wgbs_coordinates}{$annot_coordinates}{"start"};
                my $annotEnd = $DMR_annotationType_db{$wgbs_coordinates}{$annot_coordinates}{"end"};
                my $annotType = $DMR_annotationType_db{$wgbs_coordinates}{$annot_coordinates}{"type"}; 
                my @arr = split(":", $wgbs_coordinates);
                my @arr2 = split("-", $arr[1]);
                my $wgbsChr = $arr[0];
                my $wgbsStart = $arr2[0];
                my $wgbsEnd = $arr2[1];
                my $wgbsLength = $wgbsEnd - $wgbsStart + 1;
                my $str = join("\t", $DMR_CPGregion_counter{$wgbs_coordinates}, $wgbsChr, $wgbsStart, $wgbsEnd, $annotChr, $annotStart, $annotEnd, $annotType);
                # print OUT $str,"\n";
                if ($wgbsStart > $annotStart && $wgbsEnd > $annotEnd)
                    {
                       my $diff = $annotEnd - $wgbsStart + 1;
                       my $prop = $diff/$wgbsLength;
                       my $stored_prop =  $final_percentage_db{$wgbs_coordinates}{$annotType};
                       $final_percentage_db{$wgbs_coordinates}{$annotType} = $stored_prop + $prop;
                    #    print OUT "cond1\t$diff\t$prop\t$wgbsLength\t",$str,"\n";
                    }
                elsif ($wgbsStart < $annotEnd && $wgbsEnd > $annotEnd)
                    {
                        my $diff = $annotEnd - $annotStart + 1;
                        my $prop = $diff/$wgbsLength;
                        my $stored_prop =  $final_percentage_db{$wgbs_coordinates}{$annotType};
                        $final_percentage_db{$wgbs_coordinates}{$annotType} = $stored_prop + $prop;
                        # print OUT "cond1\t$diff\t$prop\t$wgbsLength\t",$str,"\n";
                    }
                elsif ($wgbsStart < $annotStart && $wgbsEnd < $annotEnd)
                    {
                        my $diff = $wgbsEnd - $annotStart + 1;
                        my $prop = $diff/$wgbsLength;
                        my $stored_prop =  $final_percentage_db{$wgbs_coordinates}{$annotType};
                        $final_percentage_db{$wgbs_coordinates}{$annotType} = $stored_prop + $prop;
                        # print OUT "cond1\t$diff\t$prop\t$wgbsLength\t",$str,"\n";
                    }

            }
    }


my $header = join("\t", "DMR_coordinates_dir","hg38_cpg_inter","hg38_cpg_islands","hg38_cpg_shelves","hg38_cpg_shores");
print OUT $header,"\n";
foreach my $wgbs_coordinates (sort keys %final_percentage_db) {
    print OUT join("\t", $wgbs_coordinates, $final_percentage_db{$wgbs_coordinates}{'hg38_cpg_inter'}, $final_percentage_db{$wgbs_coordinates}{'hg38_cpg_islands'}, $final_percentage_db{$wgbs_coordinates}{'hg38_cpg_shelves'}, $final_percentage_db{$wgbs_coordinates}{'hg38_cpg_shores'}) . "\n";
}
# print OUT Dumper \%final_percentage_db;
# print OUT Dumper \%DMR_CPGregion_counter;
# print $wgbs_coordinates Dumper \%DMR_annotationType_db;

# sub proportion_calculator{
#     my ($a, $b) = @_;
#     my $wgbs_coordinates = $a;
#     my $number_of_regions = $b;
#     # print OUT $wgbs_coordinates,"\n";
# }
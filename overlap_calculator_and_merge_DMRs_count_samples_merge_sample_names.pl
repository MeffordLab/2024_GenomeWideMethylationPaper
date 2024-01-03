use strict;
use warnings;
use Data::Dumper;
use List::Util qw(min max);
use Text::Table;

my $f1 = $ARGV[0];
open IN, $f1 or die;
my @store_db_arr = <IN>;

my %store_db;
my $region_counter = 1;
open OUT, ">$f1\_output.txt";
open OUT2, ">$f1\_test.txt";
print OUT join("\t","DMR_coordinates_dir","EpiInd","Gene","Chr","Start","End","Direction","Region", "Count_of_samples", "Sample_Name", "DMR_number_by_sample", "Cluster_number","\n");
# print OUT join("\t","DMR_coordinates_dir","EpiInd","Gene","Chr","Start","End","Direction","Region", "Count_of_samples", "\n");
print scalar(@store_db_arr), "\n";
print "Make sure to sort by chromosome and start coordinates\n";

my $lines = scalar(@store_db_arr);
for (my $i = 0; $i < $lines - 1 ; $i = $i+1)
    {
        chomp $store_db_arr[$i];
        next if $store_db_arr[$i] =~ /^DMR_coordinates_dir/;
         # print OUT $store_db[$i], "\n";
        my @arr1 = split("\t", $store_db_arr[$i]);
        # print OUT Dumper \@arr1;
        my $DMR_region_1 = $arr1[0];
        my $EpiInd_1 = $arr1[1];
        my $gene_1 = $arr1[2];
        my $chr_1 = $arr1[3];
        my $start_1 = $arr1[4];
        my $end_1 = $arr1[5];
        my $direction_1 = $arr1[6];
        
        my $sample_name_1 = $arr1[7];
        my $DMR_number_by_sample_1 = $arr1[8];
        my $DMR_length_1 = $arr1[9];
        my $j = $i + 1;
        # Get the next line
        chomp $store_db_arr[$j];
        next if $store_db_arr[$j] =~ /^DMR_coordinates_dir/;
        print OUT2 "line i: $store_db_arr[$i]\n";
        print OUT2 "line j: $store_db_arr[$j]\n";
        my @arr2 = split("\t", $store_db_arr[$j]);
        my $DMR_region_2 = $arr2[0];
        my $EpiInd_2 = $arr2[1];
        my $gene_2 = $arr2[2];
        my $chr_2 = $arr2[3];
        my $start_2 = $arr2[4];
        my $end_2 = $arr2[5];
        my $direction_2 = $arr2[6];
        
        my $sample_name_2 = $arr2[7];
        my $DMR_number_by_sample_2 = $arr2[8];
        my $DMR_length_2 = $arr2[9];
        # print "$i\t$j\n";
        print OUT2 "compare:", $start_1, "\t", $end_1, "\t", $start_2, "\t", $end_2,"\n";
        # next if $gene_1 =~ /NA/ || $gene_2 =~ /NA/;
        if ($i == 1)
            {
                # print "out\n";
                # this is for the 1st record
                check_and_store($chr_1, $start_1, $end_1, $gene_1, $direction_1, $EpiInd_1, $sample_name_1, $DMR_number_by_sample_1);
                # check_and_store($chr_1, $start_1, $end_1, $gene_1, $direction_1, $EpiInd_1);
            }
        if (($chr_1 eq $chr_2) && ($gene_1 eq $gene_2) && ($direction_1 eq $direction_2))
            {
                # print OUT $gene_1,"\t",$gene_2,"\n";
                # if (defined($store_db{$chr_1}{}))
                my ($new_start, $new_end);
                # Add condiiton if region out of boundery. not considered here for multiple regions
                if ($start_1 <= $start_2 && $start_2 < $end_1)
                    {
                        $new_start = $start_1;
                        if ($end_1 >= $end_2)
                            {
                                $new_end = $end_1;
                            }
                        elsif($end_1 < $end_2)
                            {
                                $new_end = $end_2;
                            }
                        # check_and_store($chr_1, $new_start, $new_end, $gene_1, $direction_1);
                        print OUT2 "$i,$j,$new_start,$new_end 1\n";
                    }
                elsif ($start_1 >= $start_2 && $end_2 > $start_1)
                    {
                        $new_start = $start_2;
                        if ($end_1 >= $end_2)
                            {
                                $new_end = $end_1;
                            }
                        elsif($end_1 < $end_2)
                            {
                                $new_end = $end_2;
                            }
                        # check_and_store($chr_1, $new_start, $new_end, $gene_1, $direction_1);
                        print OUT2 "$i,$j,$new_start,$new_end,2\n";
                    }
                elsif ($start_1 > $start_2 && $start_1 > $end_2)
                    {
                        $new_start = $start_2;
                        $new_end = $end_2;
                        print OUT2 "$i,$j,$new_start,$new_end,3\n";
                    }
                elsif ($end_1 < $start_2 && $end_1 < $end_2)
                    {
                        $new_start = $start_2;
                        $new_end = $end_2;
                        print OUT2 "$i,$j,$new_start,$new_end,4\n";
                    }
                # check_and_store($chr_2, $new_start, $new_end, $gene_2, $direction_1, $EpiInd_2, $sample_name_2, $DMR_number_by_sample_2);
                check_and_store($chr_2, $new_start, $new_end, $gene_2, $direction_1, $EpiInd_2, $sample_name_2, $DMR_number_by_sample_2);
                # check_and_store($chr_2, $new_start, $new_end, $gene_2, $direction_1, $EpiInd_2);
            }
        # elsif (($chr_1 eq $chr_2) && ($gene_1 eq $gene_2) && ($direction_1 ne $direction_2)) 
        #     {
        #         check_and_store($chr_2, $start_2, $end_2, $gene_2, $direction_2, $EpiInd_2, $sample_name_2, $DMR_number_by_sample_2);
        #         # check_and_store($chr_2, $start_2, $end_2, $gene_2, $direction_2, $EpiInd_2);
        #         print OUT2 "$i,$j,5\n";
        #     }
        else 
            {
                # print OUT join("\t", $chr_1, $gene_1, $direction_1, $start_1, $end_1, $region_counter) . "\n";
                check_and_store($chr_2, $start_2, $end_2, $gene_2, $direction_2, $EpiInd_2, $sample_name_2, $DMR_number_by_sample_2);
                # check_and_store($chr_2, $start_2, $end_2, $gene_2, $direction_2, $EpiInd_2);
                print OUT2 "$i,$j,$start_2, $end_2,6\n";
            }
    }
# print OUT Dumper \%store_db;
# Create the table object
# my $table = Text::Table->new("DMR_coordinates_dir","Gene","Chr","Start","End","Direction","Region", "EpiInd");


# Add data to the table
my $cluster = 1;
my @Output_array = ();
foreach my $chr (sort keys %store_db) {
    foreach my $gene (sort keys %{$store_db{$chr}}) {
        foreach my $dir (keys %{$store_db{$chr}{$gene}}) {
            foreach my $region (sort keys %{$store_db{$chr}{$gene}{$dir}}){
            my $start = $store_db{$chr}{$gene}{$dir}{$region}{'start'};
            my $end = $store_db{$chr}{$gene}{$dir}{$region}{'end'};
            my $DMR_region = $chr.":".$start."-".$end."[".$dir."]";
            my $epiind = $store_db{$chr}{$gene}{$dir}{$region}{'epiind'};
            my $sample_name = $store_db{$chr}{$gene}{$dir}{$region}{"sample_name"};
            my $DMR_number_by_sample = $store_db{$chr}{$gene}{$dir}{$region}{"DMR_number_by_sample"};
            my @samples = split(";", $epiind);
            my $count_of_samples = scalar(@samples);
            # my $region = $store_db{$chr}{$gene}{$dir}{$region};
            # $table->add($chr,$gene,$dir,$start,$end,$region);
            # print OUT join("\t", $DMR_region, $epiind, $gene, $chr,  $start, $end, $dir,$region, $count_of_samples, $sample_name, $DMR_number_by_sample, $cluster)."\n";
            my $str = join("\t", $DMR_region, $epiind, $gene, $chr,  $start, $end, $dir,$region, $count_of_samples, $sample_name, $DMR_number_by_sample);
            push(@Output_array, $str);
            # $cluster++;
            }
        }
    }
}
#Sort array by chr and start
my @sorted_1 = sort { (split('\t', $a))[3] cmp (split('\t', $b))[3] ||
                      (split('\t', $a))[4] <=> (split('\t', $b))[4] } @Output_array;
# my @sorted_2 = sort { (split('\t', $a))[4] <=> (split('\t', $b))[4] }
open OUT3, ">tempchr1-9.txt";
open OUT4, ">tempchr10-22.txt";


foreach my $line (@sorted_1)
    {
        # print OUT $line,"\t",$cluster, "\n";
        # $cluster++;
        my @arr = split("\t", $line);
        my $chr  = $arr[3];
        if ($chr eq 'chr1' || $chr eq 'chr2' || $chr eq 'chr3' || $chr eq 'chr4' || $chr eq 'chr5' || 
        $chr eq 'chr6' || $chr eq 'chr7' || $chr eq 'chr8' || $chr eq 'chr9')
            {
                print OUT3 $line,"\n";
            }
        else {
                print OUT4 $line,"\n";
        }
        
    }

close(OUT3);
close(OUT4);
system('cat tempchr1-9.txt tempchr10-22.txt > tempchr1-22.txt');
system('rm tempchr1-9.txt tempchr10-22.txt');
open IN2, "tempchr1-22.txt" or die;
my @data = <IN2>;
foreach my $line (@data)
    {
        chomp $line;
        print OUT $line,"\t", $cluster, "\n";
        $cluster++;
    }
system('rm tempchr1-22.txt');

# print OUT Dumper \@sorted_1;
print OUT2 Dumper \%store_db;
# Print the table
# print OUT $table;
sub check_and_store {
    my ($a, $b, $c, $d, $e, $f, $g, $h) = @_;
    my $chr = $a;
    my $start = $b;
    my $end = $c;
    my $gene = $d;
    my $dir = $e;
    my $epiind = $f;
    my $sample_name = $g;
    my $DMR_number_by_sample = $h;
    print OUT2 "Received in subroutine: $chr, $start, $end, $gene, $dir, $epiind, $sample_name, $DMR_number_by_sample\n";
    my $FLAG = 0;

    if (!defined($store_db{$chr}{$gene}{$dir})) {
        my $region = 1;
        print OUT2 "1st input to hash: $chr, $start, $end, $gene, $dir, $epiind, $sample_name, $DMR_number_by_sample\n\n";
        $store_db{$chr}{$gene}{$dir}{$region}{"start"} = $start;
        $store_db{$chr}{$gene}{$dir}{$region}{"end"} = $end;
        $store_db{$chr}{$gene}{$dir}{$region}{"epiind"} = $epiind;
        $store_db{$chr}{$gene}{$dir}{$region}{"sample_name"} = $sample_name;
        $store_db{$chr}{$gene}{$dir}{$region}{"DMR_number_by_sample"} = $DMR_number_by_sample;
    }
    elsif (defined($store_db{$chr}{$gene}{$dir})) {
        print OUT2 Dumper \%{$store_db{$chr}};
        my $total_stored_regions = scalar keys %{$store_db{$chr}{$gene}{$dir}};
        print OUT2 "Total regions so far: $total_stored_regions\n";
        
        for (my $region = 1; $region <= $total_stored_regions; $region = $region + 1) {
            print OUT2 "region in exists case: $region\n";
            my $determine_whether_to_end = 0;
            my ($final_start, $final_end);
            my $db_start = $store_db{$chr}{$gene}{$dir}{$region}{"start"};
            my $db_end = $store_db{$chr}{$gene}{$dir}{$region}{"end"};
            my $db_epiind = $store_db{$chr}{$gene}{$dir}{$region}{"epiind"};
            my $db_sample_name = $store_db{$chr}{$gene}{$dir}{$region}{"sample_name"};
            my $db_DMR_number_by_sample = $store_db{$chr}{$gene}{$dir}{$region}{"DMR_number_by_sample"};
            print OUT2 "inside exists: $chr, $start, $end, $gene, $sample_name, $DMR_number_by_sample, $db_start, $db_end, $region, $db_epiind, $db_sample_name, $db_DMR_number_by_sample\n";
            
            chomp($chr, $start, $end, $gene, $db_start, $db_end);
            
            if ($db_start == $start && $db_end > $end) {
                $final_start = $db_start;
                $final_end = $db_end;
                $FLAG = 0;
                print OUT2 "Condition 1\n";
            }
            elsif ($db_start < $start && $db_end == $end) {
                $final_start = $db_start;
                $final_end = $db_end;
                $FLAG = 0;
                print OUT2 "Condition 2\n";
            }
            elsif ($db_start < $start && $db_end > $end) {
                $final_start = $db_start;
                $final_end = $db_end;
                $FLAG = 0;
                print OUT2 "Condition 3\n";
            }
            elsif ($db_start > $start && $db_end < $end) {
                $final_start = $start;
                $final_end = $end;
                $FLAG = 0;
                print OUT2 "Condition 4\n";
            }
            elsif ($db_start <= $end && $db_end >= $start) {
                my $db_region_len = $db_end - $db_start + 1;
                my $overlap_region_len = min($end, $db_end) - max($start, $db_start) + 1;
                my $overlap = $overlap_region_len / $db_region_len;
                print OUT2 "db,overlap,overlap%:$db_region_len, $overlap_region_len, $overlap \n";
                if ($overlap >= 0.5) {
                    $final_start = min($start, $db_start);
                    $final_end = max($end, $db_end);
                    $FLAG = 0;
                    print OUT2 "$final_start, $final_end, Condition 5\n";
                }
            }
            else {
                $final_start = $start;
                $final_end = $end;
                $FLAG = 1;
                print OUT2 "$final_start, $final_end, Condition 6\n";
            }
            
            if ($FLAG == 0) {
                print OUT2 "here flag=0\n";
                $store_db{$chr}{$gene}{$dir}{$region}{"start"} = $final_start;
                $store_db{$chr}{$gene}{$dir}{$region}{"end"} = $final_end;
                my $new_epind = $db_epiind . ";" . $epiind;
                print OUT2 "$db_epiind, $epiind,$new_epind \n";
                $store_db{$chr}{$gene}{$dir}{$region}{"epiind"} = $new_epind;
                print OUT2 "$db_sample_name, $sample_name\n";
                my $new_sample_name = $db_sample_name . ";" . $sample_name;
                $store_db{$chr}{$gene}{$dir}{$region}{"sample_name"} = $new_sample_name;
                print OUT2 "$db_DMR_number_by_sample, $DMR_number_by_sample\n";
                my $new_DMR_number_by_sample = $db_DMR_number_by_sample . ":" . $DMR_number_by_sample;
                $store_db{$chr}{$gene}{$dir}{$region}{"DMR_number_by_sample"} = $new_DMR_number_by_sample;
                $determine_whether_to_end = 1;
                print OUT2 "Condition 10\n\n";
            }
            elsif ($FLAG == 1) {
                my $new_region_number = $region + 1;
                # Check if region exists or not
                if (defined (($store_db{$chr}{$gene}{$dir}{$new_region_number}{"start"}) && defined($store_db{$chr}{$gene}{$dir}{$new_region_number}{"end"}))) {

                
                if (($store_db{$chr}{$gene}{$dir}{$new_region_number}{"start"} == $final_start ) && $store_db{$chr}{$gene}{$dir}{$new_region_number}{"end"} == $final_end ) {
                    print OUT2 "Region $region pre-defined\n";
                    # $new_region_number = $new_region_number + 1;
                    print OUT2 "Newer region number:",$new_region_number, "\n";
                    print OUT2 "there flag=1A\n";
                    my $prior_epiind = $store_db{$chr}{$gene}{$dir}{$new_region_number}{"epiind"};
                    my $prior_sample_name = $store_db{$chr}{$gene}{$dir}{$new_region_number}{"sample_name"};
                    my $prior_DMR_number_by_sample = $store_db{$chr}{$gene}{$dir}{$new_region_number}{"DMR_number_by_sample"};
                    $store_db{$chr}{$gene}{$dir}{$new_region_number}{"start"} = $final_start;
                    $store_db{$chr}{$gene}{$dir}{$new_region_number}{"end"} = $final_end;
                    my $new_epind = $prior_epiind . ";" . $epiind;
                    print OUT2 "prior: $prior_epiind, $epiind,$new_epind \n";
                    $store_db{$chr}{$gene}{$dir}{$new_region_number}{"epiind"} = $new_epind;
                    
                    my $new_sample_name = $prior_sample_name . ";" . $sample_name;
                    print OUT2 "prior: $prior_sample_name, $sample_name, $new_sample_name\n";
                    $store_db{$chr}{$gene}{$dir}{$new_region_number}{"sample_name"} = $new_sample_name;
                    
                    my $new_DMR_number_by_sample = $prior_DMR_number_by_sample . ":" . $DMR_number_by_sample;
                    print OUT2 "prior: $prior_DMR_number_by_sample, $DMR_number_by_sample, $new_DMR_number_by_sample\n";
                    $store_db{$chr}{$gene}{$dir}{$new_region_number}{"DMR_number_by_sample"} = $new_DMR_number_by_sample;
                    $determine_whether_to_end = 1;
                    print OUT2 "Condition 11 A\n\n";
                }}
                else {
                    print OUT2 "New region number:",$new_region_number, "\n";
                    print OUT2 "there flag=1B\n";
                    $store_db{$chr}{$gene}{$dir}{$new_region_number}{"start"} = $final_start;
                    $store_db{$chr}{$gene}{$dir}{$new_region_number}{"end"} = $final_end;
                    print OUT2 "$final_start, $final_end \n";
                    print OUT2 "$epiind\n";
                    my $new_epind = $epiind;
                    $store_db{$chr}{$gene}{$dir}{$new_region_number}{"epiind"} = $new_epind;
                    print OUT2 "$sample_name\n";
                    my $new_sample_name = $sample_name;
                    $store_db{$chr}{$gene}{$dir}{$new_region_number}{"sample_name"} = $new_sample_name;
                    print OUT2 "$DMR_number_by_sample\n";
                    my $new_DMR_number_by_sample = $DMR_number_by_sample;
                    $store_db{$chr}{$gene}{$dir}{$new_region_number}{"DMR_number_by_sample"} = $new_DMR_number_by_sample;
                    $determine_whether_to_end = 1;
                    print OUT2 "Condition 11 B\n\n";
                }
                
            }
            if ($determine_whether_to_end == 1) {
                last;
            }
        }
    }
}
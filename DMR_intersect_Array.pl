# use strict;
use warnings;
use Data::Dumper;



my $file1 = "Array.granges.DMRcate.EPICarray.fromRGSet.reverse.p05.betacutoff0.05.hg19.txt";
open IN, $file1 or die;
my @array_DMRcate = <IN>;
my $head1 = $array_DMRcate[0];
# print $head1, "\n";
shift @array_DMRcate; #Remove headers to sort
my @sorted_array_DMRcate = sort {
    (split('\t',$a))[0] cmp (split('\t',$b))[0] ||
    (split('\t',$a))[1] <=> (split('\t',$b))[1]
} @array_DMRcate;


my $file2 = "Array.model_matrix_reversedCHD2_16n_control_18n_preprocessFunnorm_bumphunter_0.05_1000_dmrs_p05.txt";
open IN2, $file2 or die;
my @array_Bumphunter = <IN2>;
my $head2 = $array_Bumphunter[0];
shift @array_Bumphunter;
my @sorted_array_Bumphunter = sort {
    (split('\t',$a))[0] cmp (split('\t',$b))[0] ||
    (split('\t',$a))[1] <=> (split('\t',$b))[1]
} @array_Bumphunter;


open OUT, ">Array_final_output.0.05_2.txt";
print OUT "DMRcate.chr\tDMRcate.start\tDMRcate.end\tDMRcate.width\tBumphunter.chr\tBumphunter.start\tBumphunter.end\tBumphunter.width\toverlap.chr\toverlap.start\toverlap.end\toverlap\tgene\tDMRcate.methlyDiff\tBumphunter.methylDiff\tAvg.methylDiff\tdirection\n";

open OUT2, ">test2.txt";


# print OUT Dumper \@sorted_array_DMRcate;

my $lines = scalar(@sorted_array_DMRcate);
my $lines2 = scalar(@sorted_array_Bumphunter);

for (my $i = 0; $i < $lines - 1 ; $i = $i+1)
    {
        chomp $sorted_array_DMRcate[$i];
        next if $sorted_array_DMRcate[$i] =~ /^seqnames/;
         # print OUT $store_db[$i], "\n";
        my @arr1 = split("\t", $sorted_array_DMRcate[$i]);
        # print OUT Dumper \@arr1;
        my $chr_1 = $arr1[0];
        my $start_1 = $arr1[1];
        my $end_1 = $arr1[2];
        my $noCpGs = $arr1[5];
        my $sigValue_Fisher = $arr1[9];
        my $methylDiff_1 = $arr1[11];
        my $gene_1 = $arr1[12];
        $gene_1 =~ s/\n|\r|\t//g;
        my $DMR_region_1 = $arr1[13];
        my $DMR_region_1_width = $end_1 - $start_1 + 1;
        next if ($sigValue_Fisher > 0.05); # Skip if not significant
        next if ($DMR_region_1_width < 50); # Skip if length of dmr is <50
        next if ($noCpGs < 2); # Skip if noCpgs is <2
        next if ($chr_1 eq "chrX" || $chr_1 eq "chrY"); # Skip sex chromosomes
        my $direction_1 = 0; # Hypo
        if ($methylDiff_1 > 0) {
            $direction_1 = 1; # Hyper
        }
        my $overlap;
        # Get each line from bumphunter file
        for (my $j = 0; $j < $lines2 ; $j++)
            {
                chomp $sorted_array_Bumphunter[$j];
                next if $sorted_array_Bumphunter[$j] eq "chr";
                my @arr2 = split("\t", $sorted_array_Bumphunter[$j]);
                my $chr_2 = $arr2[0];
                my $start_2 = $arr2[1];
                my $end_2 = $arr2[2];
                my $methylDiff_2 = $arr2[3];
                my $sigValue_pValue = $arr2[10];
                my $DMR_region_2 = $arr2[14];
                my $DMR_region_2_width = $end_2 - $start_2 + 1;

                next if ($sigValue_pValue > 0.05);# Skip if not significant
                next if ($DMR_region_2_width < 50); # Skip if length of dmr is <50
                next if ($chr_2 eq "chrX" || $chr_2 eq "chrY");
                my $direction_2 = 0; # Hypo
                if ($methylDiff_2 > 0) {
                    $direction_2 = 1; # Hyper
                }
           
        # print "$i\t$j\n";
        print OUT2 "compare:", $start_1, "\t", $end_1, "\t", $start_2, "\t", $end_2,"\n";
        my $FLAG = 0;
        if (($chr_1 eq $chr_2) && ($direction_1 == $direction_2))
            {
                print OUT2 "inside:", $start_1, "\t", $end_1, "\t", $start_2, "\t", $end_2,"\t",$direction_1,"\t",$direction_2,"\n";
                # if (defined($store_db{$chr_1}{}))
                my ($new_start, $new_end);
                # Add condiiton if region out of boundery. not considered here for multiple regions
                if ($start_1 <= $start_2 && $start_2 < $end_1)
                    {
                        
                        # $new_start = $start_1;
                        if ($end_1 >= $end_2)
                            {
                                # $new_end = $end_1;
                                $overlap = $end_2 - $start_2 + 1;
                                if ($overlap >= 50)
                                    {
                                        $FLAG = 1;
                                        $new_start = $start_2;
                                        $new_end = $end_2;
                                    }
                            }
                        elsif($end_1 < $end_2)
                            {
                                # $new_end = $end_2;
                                $overlap = $end_1 - $start_2 + 1;
                                if ($overlap >= 50)
                                    {
                                        $FLAG = 1;
                                        $new_start = $start_2;
                                        $new_end = $end_1;
                                    }
                            }
                        # check_and_store($chr_1, $new_start, $new_end, $gene_1, $direction_1);
                        print OUT2 "Condition1: $i,$j,$overlap,$FLAG,$direction_1,$direction_2,1\n";
                    }
                elsif ($start_1 >= $start_2 && $end_2 > $start_1)
                    {
                        # $new_start = $start_2;
                        if ($end_1 >= $end_2)
                            {
                                # $new_end = $end_1;
                                $overlap = $end_2 - $start_1 + 1;
                                if ($overlap >= 50)
                                    {
                                        $FLAG = 1;
                                        $new_start = $start_1;
                                        $new_end = $end_2;
                                    }
                            }
                        elsif($end_1 < $end_2)
                            {
                                # $new_end = $end_2;
                                $overlap = $end_1 - $start_1 + 1;
                                if ($overlap >= 50)
                                    {
                                        $FLAG = 1;
                                        $new_start = $start_1;
                                        $new_end = $end_1;
                                    }
                            }
                        # check_and_store($chr_1, $new_start, $new_end, $gene_1, $direction_1);
                        print OUT2 "Condition2: $i,$j,$overlap,$FLAG,$direction_1,$direction_2,2\n";
                    }
                elsif ($start_1 > $start_2 && $start_1 > $end_2)
                    {
                        # $new_start = $start_2;
                        # $new_end = $end_2;
                        print OUT2 "Condition3: $i,$j,NO OVERLAP,$direction_1,$direction_2,3\n";
                    }
                elsif ($end_1 < $start_2 && $end_1 < $end_2)
                    {
                        # $new_start = $start_2;
                        # $new_end = $end_2;
                        print OUT2 "Condition4: $i,$j,NO OVERLAP,$direction_1,$direction_2,4\n";
                    }
                # check_and_store($chr_2, $new_start, $new_end, $gene_2, $direction_1, $EpiInd_2, $sample_name_2, $DMR_number_by_sample_2);
                # #check_and_store($chr_2, $new_start, $new_end, $gene_2, $direction_1, $EpiInd_2, $sample_name_2, $DMR_number_by_sample_2);
                # check_and_store($chr_2, $new_start, $new_end, $gene_2, $direction_1, $EpiInd_2);
                if ($FLAG == 1)
                    {
                        my $str1 = $chr_1."\t".$start_1."\t".$end_1."\t".$DMR_region_1_width."\t".$chr_2."\t".$start_2."\t".$end_2."\t".$DMR_region_2_width."\t".$chr_1."\t".$new_start."\t".$new_end."\t".$overlap."\t";
                        my $avg_methylDiff = ($methylDiff_1 + $methylDiff_2)/2;
                        my $direction;
                        if ($avg_methylDiff > 0) {$direction = "hyper";}
                        elsif($avg_methylDiff <0) {$direction = "hypo";}
                        my $str2 = $gene_1."\t".$methylDiff_1."\t".$methylDiff_2."\t".$avg_methylDiff."\t".$direction."\n";
                        print OUT $str1.$str2;
                    }
            }
        
    }
}

# open OUT, ">${extracted_filename}.OUTPUT.txt";


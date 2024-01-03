#!/usr/bin/perl

use strict;
use warnings;
use LWP::Simple;

# Function to generate genomic ranges
sub generate_genomic_ranges {
    my ($num_ranges, $min_length, $max_length, $chromosomes, $chrom_lengths) = @_;

    my @genomic_ranges;

    for my $i (1..$num_ranges) {
        my $chromosome = $chromosomes->[rand @$chromosomes];
        my $chr_length = $chrom_lengths->{$chromosome};
        my $start_position = int(rand($chr_length - $max_length)) + 1;
        my $end_position = $start_position + int(rand($max_length - $min_length + 1)) + $min_length;

        push @genomic_ranges, [$chromosome, $start_position, $end_position];
    }

    return \@genomic_ranges;
}

# Parameters
my $num_ranges = 4767;
my $min_length = 50;
my $max_length = 3100;
# my $chrom_info_url = 'chromInfo.txt';
my @chromosomes = map { "chr$_" } 1..22;

# Download chromosome information for hg38
# my $chrom_info = get($chrom_info_url) or die "Couldn't download $chrom_info_url: $!";
my $chrom_info = 'chromInfo.txt';
open IN, $chrom_info or die;
my @ch_infor = <IN>;
my %chrom_lengths;
foreach my $i (@ch_infor)
    {
        chomp $i;
        my @a = split("\t", $i);
        my $chrom = $a[0];
        my $length = $a[1];
        $chrom_lengths{$chrom}=$length;
    }
# my %chrom_lengths = map { my ($chrom, $length) = split(/\t/); $chrom => $length } split(/\n/, $chrom_info);

# Generate genomic ranges
my $genomic_ranges = generate_genomic_ranges($num_ranges, $min_length, $max_length, \@chromosomes, \%chrom_lengths);
$genomic_ranges = [sort { $a->[0] cmp $b->[0] or $a->[1] <=> $b->[1] } @$genomic_ranges];
# Save genomic ranges to BED file
my $bed_file = 'Random_genomic_ranges_4767_Rep3.csv';
open my $bed_fh, '>', $bed_file or die "Cannot open $bed_file for writing: $!";
for my $range (@$genomic_ranges) {
    print $bed_fh join("\t", @$range), "\n";
}
close $bed_fh;


print "Saved genomic ranges to: $bed_file\n";

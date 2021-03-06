#!/usr/bin/perl

use strict 'vars';

my %dbsnp;

my $prog = 0;

open(fh, "ucsc_146.snps.GRCh38.final") or die("Cannot open ucsc_146.snps.GRCh38.final");

while (my $line = <fh>) {
	chomp($line);
	next if ($line =~ /^#/);

	$line =~ /^(\S+)\t(\S+)/;
	my ($chr, $pos) = ($1,$2);

	$dbsnp{$chr."_".$pos} = 1;

	$prog ++ ;

	if ( ($prog % 200000) == 0) {
		print(STDERR "chr: $chr\n");
		print(STDERR "pos: $pos\n");
		print(STDERR "$prog / 144,859,982\n");
	}
}

close(fh);

my @files = <./calls.prefinal/*.calls.annotated.no_MHC>;

foreach my $file (@files) {
	print("$file\n");

	open(fh, $file);
	open(fh_out, ">" . $file . ".no_ucsc_146");

	while (my $line = <fh>) {
		chomp($line);

		$line =~ /^(\S+) (\S+)/;
		my ($chr, $pos) = ($1,$2);
		$chr =~ s/chr//;

		if ($dbsnp{$chr."_".$pos} eq "") {
			print(fh_out "$line\n");
		}
	}

	close(fh);
	close(fh_out);
}

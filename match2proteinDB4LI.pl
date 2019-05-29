#!/usr/bin/perl

open(IN,"ToxoDB-41_TgondiiGT1_AnnotatedProteins.fasta") or die "Could not open the file:$!\n";

while(<IN>)
{
	chomp;
	unless(/^>/)
	{
		$seq.="$_";
	}	
}
close IN;

$seq=~tr /[IL]/B/;

open(IN2,"Toxoplasma_Unassigned_6frame_search_02_Peptide_Groups.txt") or die "Could not open the file:$!\n";
while(<IN2>)
{
	chomp;
	unless (/^Checked/)
	{
		#$pep = (split /\./,(split /\t/)[2])[1];
		$pep= (split /\t/)[2];
		$pep=~tr /[IL]/B/;
		unless ($seq =~ /$pep/)
		{
			print "$_\n";
		}
	}
	else
	{
		print "$_\n";
	}	
}
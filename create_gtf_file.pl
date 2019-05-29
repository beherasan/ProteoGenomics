#!/usr/bin/perl
open (FILE, "Toxoplasma_fetch_pos.txt") or die $!;
open (OUT , ">Toxoplasma_GSSPs.gtf") or die $!;
open (FOUT, ">Toxoplasma_with_gtf_annotation.txt") or die $!;
#print FOUT "Sequence\t# PSMs\t# Proteins\t# Protein Groups\tProtein Group Accessions\tModifications\tMH+ [Da]\tA2\tG2\tM2\tS2\tXCorr A2\tXCorr G2\tXCorr M2\tXCorr S2\tProbability A2\tProbability G2\tProbability M2\tProbability S2\tB2\tH2\tN2\tT2\tXCorr B2\tXCorr H2\tXCorr N2\tXCorr T2\tProbability B2\tProbability H2\tProbability N2\tProbability T2\tC2\tI2\tO2\tXCorr C2\tXCorr I2\tXCorr O2\tProbability C2\tProbability I2\tProbability O2\tD2\tJ2\tP2\tXCorr D2\tXCorr J2\tXCorr P2\tProbability D2\tProbability J2\tProbability P2\tE2\tK2\tQ2\tXCorr E2\tXCorr K2\tXCorr Q2\tProbability E2\tProbability K2\tProbability Q2\tF2\tL2\tR2\tXCorr F2\tXCorr L2\tXCorr R2\tProbability F2\tProbability L2\tProbability R2\t# Missed Cleavages\tStrand\tStart\tEnd\tGene_id\tTranscript_id\n";
$no=1;
while (<FILE>)
{
	chomp($_);
	if ($_ !~ /^Checked/)
	{
		@lines = split (/\t/, $_);
		print OUT "$lines[-1]\tGSSP\tCDS\t$lines[-3]\t$lines[-2]\t\.\t$lines[-4]\t0\tgene_id \"$no\_g_GSSP\"\; transcript_id \"$no\_t_GSSP\"\;\n";
		print FOUT "$_\t$no\_g_GSSP\t$no\_t_GSSP\n";
		$no++;
	}
	else
	{
		print FOUT "$_\tGene_id\tTranscript_id\n";
	}
}

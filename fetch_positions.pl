#!/usr/bin/perl
#system ("date");
open(FILE, "ToxoDB-42_TgondiiGT1_Genome_sixframe.fasta") or die $!;
%prt=();
%cont = ();
while(<FILE>)
{
    chomp($_);
    $_ =~ s/\r//g;
    if ($_ =~ /^\>/)
    {
		@gi = split (/\|/, $_);
		@positi = split (/\#/, $_);
		@conting_nu = split (/\#/, $gi[-1]);
		$conting_nu[0]=~ s/\s//g;
	}
    else
    {
		chomp ($_);
		$prt{$gi[1]} .= "$positi[-1];$_";
		$cont{$gi[1]} = "$conting_nu[0]";
    }
}

open (NOTMAPD, "Toxoplasma_Unassigned_6frame_search_02_Peptide_Groups_unique.txt") or die $!;
open (OUT, ">Toxoplasma_fetch_pos.txt") or die $!;
while ($hp3f = <NOTMAPD>)
{
	chomp($hp3f);
	$hp3f =~ s/\r//g;
	$hp3f =~ s/"//g;
	if ($hp3f !~ /^Checked/)
	{
		@lines = split (/\t/,$hp3f);
		$ps_seq = $prt{$lines[11]};#master protein accession
		#print "$ps_seq\n";
		if(!exists $prt{$lines[11]}){
		print "----> $lines[15]\t$ps_seq\n";}  		
		@subject = split(/\;/,$ps_seq);
		@position = split(/\_/, $subject[0]);
		@sp_ep = split (/\-/, $position[1]);
		$strand = $position[2];
		if ($strand =~ /^f/)
		{
			$start = $sp_ep[0]-1; ## Removed -1 since it is the exact start position
			$end = $sp_ep[1];
			$search = $lines[2];#peptide sequence
			$result = index($subject[1], $search);#searching  the peptide in sequnece $subject[1] is sequence and $serch is peptide
			$len = length($search);#length of peptide
			$pep_tr_start = ($result+1)*3;#+1 because the length of string (sequnece) while searching starts from 0
			$pep_tr_start = $pep_tr_start-2;#-2 because it is a codon of three bases, so we remove two bases to fetch the first base
			$pep_tr_start = $pep_tr_start + $start;#$start is the starting position of the sequnece in sixframe database
			$len = $len*3;#because one amino acid contains 3 nucleotides
			$pep_tr_end = $pep_tr_start + $len-1;#end positions
		
			print OUT "$hp3f\t+\t$pep_tr_start\t$pep_tr_end\t$cont{$lines[11]}\n";
		}
		elsif ($strand =~ /^r/)
		{
			$start = $sp_ep[0];
			$end = $sp_ep[1];
			$search = $lines[2];
			$result = index($subject[1], $search);	
			$len = length($search);
				$initial_end = $result+$len;
				$fend = $initial_end * 3;
				$fend = ($start - $fend)+1;
				$fstart = ($fend + ($len *3))-1;
			print OUT "$hp3f\t-\t$fend\t$fstart\t$cont{$lines[11]}\n";
		}
	}
	else
	{
		print OUT "$hp3f\tstrand\tstart\tend\tchromosome\n";
	}	
}

#system ("date");
#=cut
#!/usr/bin/perl

open(IN,"Toxoplasma_with_gtf_annotation.txt") or die "Could not open the file:$!\n";
open(OUT,">Toxoplasma_categorisation.txt") or die "Could not create the file:$!\n";

while(<IN>)
{
	chomp;
	$_=~s/\r//g;
	$line=$_;
	unless(/^Checked/)
	{
		($start_ann,$end_ann,$strand_ann,$chr_ann)=(split /\t/)[-5,-4,-6,-3];
		#@line=split(/\t/,$_); 
		#$start_ann=$line[52];$end_ann=$line[53];$strand_ann=$line[51];
		#print OUT "$start_ann\t$end_ann\t$strand_ann\n";
		$flag=0;
		open(IN2,"ToxoDB-42_TgondiiGT1.gff") or die "Could not open the file:$!\n";
		while(<IN2>)
		{
			chomp;
			$_=~s/\r//g;
			#$line=$_;
			($start_gff,$end_gff,$strand_gff,$type,$chr_gff)=(split /\t/)[3,4,6,2,0];
			if($chr_gff eq $chr_ann && $type eq 'CDS')
			{
				if($strand_ann eq $strand_gff)
				{
					#print OUT "$start_ann\t$end_ann\t$start_gff\t$end_gff\n";
					if($start_ann < $start_gff and $end_ann > $start_gff and $end_ann < $end_gff)
					{
						if($strand_ann eq '+')
						{
							print OUT "$line\tN-Terminal Extension\n";
						}
						elsif($strand_ann eq '-')
						{
							print OUT "$line\tC-Terminal Extension\n";
						}
						$flag=1;
						last;
					}
					elsif($start_ann > $start_gff and $start_ann < $end_gff and $end_ann > $end_gff)
					{	
						if($strand_ann eq '+')
						{
							print OUT "$line\tC-Terminal Extension\n";
						}
						elsif($strand_ann eq '-')
						{
							print OUT "$line\tN-Terminal Extension\n";
						}
						$flag=1;
						last;
					}
					elsif($start_ann > $start_gff and $start_ann < $end_gff and $end_ann < $end_gff and $end_ann > $start_gff)
					{
						print OUT "$line\tAlternative frame of translation\n";
						$flag=1;
						last;
					}
				}
			}
			#print OUT "$_\n";
			if(eof && $flag == 0)
			{
				print OUT "$line\tIntergenic Region\n";
			}


		}

		close IN2;
	}
	else
	{
		print OUT "$_\tCategorisation_type\n";
	}
}

#!/usr/bin/perl
#
#open(IN,"Bos_taurus_op.fna")  or die "Could not ceate the file:$!\n";
open(IN,"test_genome.fa")  or die "Could not ceate the file:$!\n";
while(<IN>)
{
	chomp;
	$_=~s/\r//g;
	if(/^>/)
	{
		($tr_num,$chr_num,$pos)=(split /\s/)[0,2,3];
		$tr_num=~s/\>//;
		$hash_ref{$tr_num}="$chr_num|$pos";
	}
}
close IN;

#open(IN2,"Bos_taurus_op_3frame.fasta") or die "Could not create the file:$!\n";
open(IN2,"test_3frame.fa") or die "Could not create the file:$!\n";
while(<IN2>)
{
	chomp;
	$_=~s/\r//g;
	if(/^>/)
	{
		$id2=$_;$id2=~s/\>//;
		($pos2)=(split /\|/)[1];
		$id =(split /\_/,$id2)[0];
	}
	else
	{
		$hash_3frame{$id2}="$pos2|$_";
	}
}
close IN2;

open(PEP,"Milk_Unassigned_Deoni_3frame_search_Peptide_Groups_unique.txt") or die "Could not open the file:$!\n";
while(<PEP>)
{
	chomp;
	$_=~s/\r//g;
	unless(/^Checked/)
	{
		($pep,$Allmaster)=(split /\t/)[2,10];
		if(exists $hash_3frame{$Allmaster})
		{
			$ps_seq = (split /\|/,$hash_3frame{$Allmaster})[1];
			#print "$Allmaster\t$hash_3frame{$Allmaster}\n";
			## get the position from frame
			$frame_pos=(split /\_/,$Allmaster)[-2];
			#print "$frame_pos\n";
			$frame_start=(split /\-/,$frame_pos)[0];
			#print "$frame_start\n";
			###############
			$search=(split /\./,$pep)[1];
			$result = index($ps_seq, $search);$result+=1;
			#print "$search\t$result\n";
			$tr=(split /\_/,$Allmaster)[0];
			$chr_number=(split /\|/,$hash_ref{$tr})[0];
			#print "#######\n";
			$ref_all=$hash_ref{$tr};
			($ref_chr,$ref_pos)=(split /\|/,$ref_all);
			@all_pos=(split /\,/,$ref_pos);
			$diff_len=$diff=$start_sw=$exon_count=$previous_length=0;$type="";
			$genome2add = (length($search))*3;
			%hash_exon=();
			for($i=0;$i< scalar(@all_pos);$i++)# $p (@all_pos)
			{
				$p=$all_pos[$i];
				($ref_s,$ref_e)=(split /\-/,$p)[0,1];
				#print "Santosh\t$ref_s\t$ref_e\n";
				$diff_ins = ($ref_e-$ref_s)+1;
				$diff_len+=$diff_ins;
				$result3 = $result*3;
				$result3+=$frame_start;
				$end_pos= ($result3+$genome2add)-1;
				$exon_count++;				
				if($start_sw == 0){
					if($result3 <= $diff_len)
					{
						#print "Santosh1\t$result3\t$diff_len\t$previous_length\n";
						$toadd= $result3-$previous_length;
						$start=$ref_s+($toadd-4);
						if($chr_number=~/\-/) ## Edit for negative strand
						{
							$start=$ref_e-($toadd-4);
						}
						#print "$p\t$start\n";
						$start_sw=1;
						$hash_exon{$exon_count}="";
					}
				}
				if($start_sw == 1)
				{
					if($end_pos <= $diff_len)
					{
						$toadd= $end_pos-$previous_length;
						$end=$ref_s+($toadd-4);
						if($chr_number=~/\-/) ## Edit for negative strand
						{
							$end=$ref_e-($toadd-4);
						}						
						#print "$start\t$end\n";
						$start_sw=2;
						if(exists $hash_exon{$exon_count})
						{
							$type="Normal";
						}
						else
						{
							$type="Junctional";
						}
					}
				}				
				if($start_sw == 2)# || $i== (scalar(@all_pos)-1))
				{
					$d = chop($chr_number);
					print "$_\t$type\t$d\t$start\t$end\t$chr_number\n";
					last;
				}
				$previous_length=$diff_len;
			}
		}
	}
}
=cut
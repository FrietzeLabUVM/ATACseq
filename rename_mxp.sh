#parallel arrays
old=(MXP5_GFP_rep1_Ad21 MXP5_G160op_rep1_Ad23 MXP5_G160om_rep1_Ad25 MXP5_I80op_rep1_Ad22 MXP5_I160op_rep1_Ad24 MXP5_I160om_rep1_Ad26)
new=(MXP5_GFP_rep1.G80op_Ad21 MXP5_GFP_rep2.G160op_Ad23 MXP5_GFP_rep3.G160om_Ad25 MXP5_IK_rep1.I80op_Ad22 MXP5_IK_rep2.I160op_Ad24 MXP5_IK_rep3.I160om_Ad26)

trgt=$(pwd)

i=0
while [ $i -lt ${#old[@]} ]; do
  echo $i
  o=${old[$i]}
  n=${new[$i]}
  echo old is $o
  echo new is $n
  i=$(( $i + 1 ))
  all_f=$trgt/$o*
  for f in $all_f; do
    if [ -f $f ] || [ -d $f ]; then
      echo $f
      nf=${f/$o/$n}
      echo $nf;
      mv $f $nf 
    fi
  done
done

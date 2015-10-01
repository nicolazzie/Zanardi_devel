#file to convert data for GSPREP

def ped_conversion(pedfile,save):
    recode={'11':'0','22':'2','12':'1','21':'1','00':'3'}
    #plink conversione in 1/2 format
    animal_list=[]
    output=open(save,'w')
    for line in open(pedfile):
        breed,ID,sire,dame,sex,phe,geno=line.strip().split(' ',6)
        geno=geno.split()
        genotype=[recode.get(geno[x]+geno[x+1],'!') for x in range(0,len(geno)-1,2)]
        if genotype.count('!'): return (False,"Error with recode option!! ")
        output.write('%s %s\n' % (ID,' '.join(genotype) ))
        animal_list.append(ID)
    return(True,'ok',animal_list)

def pedig_save(pedigree,save):
    output=open(save,'w')
    for line in open(pedigree):
        ID,sire,dam,birth,sex=line.strip().split(';')
        if (sire=='0' and dam != '0') or (dam=='0' and sire != '0'):output.write('%s %s %s\n' % (ID,0,0))
        else:output.write('%s %s %s\n' % (ID,sire,dam))

def pheno_control(pheno):
    animal_list=[]
    EBV_sum=[]        
    for line in open(pheno):
        ID,EBV,ACC=line.strip().split(';')
        animal_list.append(ID)
        EBV_sum.append(float(EBV))
    return(animal_list,EBV_sum)

def pheno_save(pheno,save):
    output=open(save,'w')
    for line in open(pheno):
        ID,EBV,ACC=line.strip().split(';')
        output.write('%s %s %s\n' % (ID,EBV,ACC ))


def id_control(geno,pheno,pedig,path):
    error=False
    ID_pheno=dict(((i.strip().split(';')[0]),0) for i in open(pheno)  )
    ID_pedig=dict(((i.strip().split(';')[0]),0) for i in open(pedig)  )

    for line in open(geno):
        ID_geno=line.strip().split()[1]
        if (not ID_pheno.has_key(ID_geno) or not ID_pedig.has_key(ID_geno)) and not error:
            output=open(path+'/Error_ID_in_GSPREP.txt','w')
            output.write('ID_Animal;Where_Not_Found\n')
            error=True
        if not ID_pheno.has_key(ID_geno):output.write('%s;%s\n' % (ID_geno,'Phenotype_file' ))
        if not ID_pedig.has_key(ID_geno):output.write('%s;%s\n' % (ID_geno,'Pedigree_file'))
    
    return(error,path+'/Error_ID_in_GSPREP.txt')

#program to run OPTIPREP option

## Creates pedigree (first part) and ped/gen files
def opti_control(pedfile,pedigree,path,name):
    ##pedigree check
    ID_pedigree={'0':[0,0,0,0]}
    output_pedig=open(path+'/OPTIMATE'+name+'.pedig','w')
    
    for n,line in enumerate(open(pedigree)):
        ID,sire,dam,birth,sex=line.strip().split(';')
        ID_pedigree[ID]=[sire,dam,sex,n+1]
        output_pedig.write('%s %s %s \n' % (n+1,ID_pedigree[sire][3],ID_pedigree[dam][3]))

    ##ped check
    write_sire=False; write_dam=False
    for line in open(pedfile):
        breed,ID,sire,dame,sex,phen,geno=line.strip().split(' ',6)
        #split sire
        if ID_pedigree[ID][2]=='M':
            if not write_sire:
                output_sire=open(path+'/OPTIMATE_SIRE'+name+'.ped','w')
                output_sire_gen=open(path+'/OPTIMATE_SIRE'+name+'.gen','w')
                write_sire=True
            output_sire.write(line)
            output_sire_gen.write('%s %s %s\n' % (ID_pedigree[ID][3],ID_pedigree[ID_pedigree[ID][0]][3],ID_pedigree[ID_pedigree[ID][1]][3]))
            
        #split dam
        if ID_pedigree[ID][2]=='F':
            if not write_dam:
                output_dam=open(path+'/OPTIMATE_DAM'+name+'.ped','w')
                output_dam_gen=open(path+'/OPTIMATE_DAM'+name+'.gen','w')
                write_dam=True
            output_dam.write(line)
            output_dam_gen.write('%s %s %s\n' % (ID_pedigree[ID][3],ID_pedigree[ID_pedigree[ID][0]][3],ID_pedigree[ID_pedigree[ID][1]][3]))

    return(True,path+'/OPTIMATE_[SIRE/DAM]'+name+'.[ped/gen]',path+'/OPTIMATE'+name+'.pedig')

## Creates phenotype file
def pheno_OPT_save(pheno,save):
    output=open(save,'w')
    for line in open(pheno):
        ID,EBV,ACC=line.strip().split(';')
        output.write('%s %s\n' % (ID,EBV))

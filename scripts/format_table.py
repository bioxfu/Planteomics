#! /usr/bin/env python

import re

prot2seq = {}
prot2desc = {}

with open('TAIR10_pep_desc_seq.tsv') as f:
	for line in f:
		lst = line.strip().split('\t')
		prot2seq[lst[0]] = lst[-1]
		prot2seq[lst[0]] = lst[-1]


with open('tables/combine_supp_tables_detected.tsv') as f:
	for line in f:
		lst = line.strip().split('\t')
		prots, pep, modpep, clas, diff, expt = lst
		modpep = re.sub('\(.+?\)', '', re.sub('\(18\)', '*', modpep))[1:-1]
		for x in prots.split(';'):
			if x.endswith('.1'):
				if x in prot2seq:
					gene = re.sub('\..+', '', x)
					prot = prot2seq[x]
					prot_ext = '_' * 15 + prot + '_' * 15
					start = prot.find(pep) + 1
					pos = []
					for i in range(len(modpep)):
						if modpep[i] == '*':
							pos.append(i + start - 1 - len(pos))
					aa = [prot[p-1] for p in pos]
					for i in range(len(pos)):
						pos_ext = pos[i] + 15
						window = prot_ext[(pos_ext-16):(pos_ext+15)]
						siteID = gene + '_' + str(pos[i]) + aa[i]
						print siteID + '\t' + gene + '\t' + x + '\t' + str(pos[i]) + '\t' + aa[i] + '\t' + window + '\t' + expt + '\t' + clas + '\t' + diff

with open('tables/combine_supp_tables_induced.tsv') as f:
	for line in f:
		lst = line.strip().split('\t')
		prots, pos, diff, clas, expt = lst
		prots = prots.split(';')
		pos = [int(x) for x in pos.split(';')]

		for i in range(len(prots)):
			x = prots[i]
			if x.endswith('.1'):
				p = pos[i]
				gene = re.sub('\..+', '', x)
				prot = prot2seq[x]
				prot_ext = '_' * 15 + prot + '_' * 15
				aa = prot[p-1]
				pos_ext = p + 15
				window = prot_ext[(pos_ext-16):(pos_ext+15)]
				siteID = gene + '_' + str(p) + aa
				print siteID + '\t' + gene + '\t' + x + '\t' + str(p) + '\t' + aa + '\t' + window + '\t' + expt + '\t' + clas + '\t' + diff


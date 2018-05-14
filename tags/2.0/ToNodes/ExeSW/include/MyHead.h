///// Head file ///////
#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <string>
#include <fstream>
#include <vector>
#include <sstream>

///// ROOT libraries

#include "TTree.h"
#include "TFile.h"
#include "TMath.h"
#include "TH1.h"
#include "TChain.h"
#include "TH1D.h"

/////////////////////////////////////////////////

extern void process_file(TH1D *histo,std::string j1_line);
extern void loop_on_list(char *list,std::vector<std::string> &list_vector);
extern void get_name(std::string all_path,std::string &f_name);
extern void read_SBI_data(Float_t &g_lat,Float_t &g_lon,Float_t &geo_lat,Float_t &geo_lon,Float_t sat_ra[],Float_t sat_dec[],UInt_t &sec,UShort_t &n_ev,bool &good,TChain* tree,std::string j1_line);

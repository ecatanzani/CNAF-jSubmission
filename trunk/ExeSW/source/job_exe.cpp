#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <string>
#include <fstream>
#include <vector>

#include "TTree.h"
#include "TFile.h"
#include "TMath.h"
#include "TH1.h"
#include "TChain.h"
#include "TH1D.h"

using namespace std;

void process_file(TH1D *histo,string j1_line);
void loop_on_lis(char *list,vector<string> &list_vector); 

int main(int argc, char* argv[]) {
  
  vector<string> input_BACH_files;
  
  loop_on_list(argv[1],input_BACH_files);
  
  

//loop lista
  // file 0 -> prendo il nome e definisco il nome del file di output
  // file i-esimo --> vector<string>

  //creo TFIle output
  //creo histogrammi

  //loop vector <string> --> process_file(...)

  TFile *out_file = new TFile("results.root","RECREATE"); //nome unico
  TH1D *histo = new TH1D("histo","histo",1000,-180,180);
  ifstream in_file(list_file.c_str());
  if(!in_file.is_open()) {
    cout<<"\n\n ERROR: no such file to open \n\n";
    exit(-1);
  }
  while(getline(in_file,j1_line)) {
    process_file(histo,j1_line);


  }
  in_file.close();
  out_file->Write();
  return 0;
}

void process_file(TH1D *histo,string j1_line) {
  
  Float_t g_lat = 0,g_lon = 0,geo_lat = 0,geo_lon = 0,sat_ra[3],sat_dec[3];
  UInt_t sec = 0;
  UShort_t n_ev = 0;
  bool good = true;
  Int_t chain_entries;

  TChain *tree= new TChain("SBItree");
  
  for(Int_t idx=0; idx<3; idx++) {
    sat_ra[idx] = 0;
    sat_dec[idx] = 0;
  }

  tree->Add(j1_line.c_str());
  
  tree->SetBranchAddress("second",&sec);
  tree->SetBranchAddress("goodsbi",&good);
  tree->SetBranchAddress("glon",&g_lon);
  tree->SetBranchAddress("glat",&g_lat);
  tree->SetBranchAddress("nev",&n_ev);
  tree->SetBranchAddress("ra_scx",&sat_ra[0]);
  tree->SetBranchAddress("ra_scy",&sat_ra[1]);
  tree->SetBranchAddress("ra_scz",&sat_ra[2]);
  tree->SetBranchAddress("dec_scx",&sat_dec[0]);
  tree->SetBranchAddress("dec_scy",&sat_dec[1]);
  tree->SetBranchAddress("dec_scz",&sat_dec[2]);
  tree->SetBranchAddress("lat_geo",&geo_lat);
  tree->SetBranchAddress("lon_geo",&geo_lon);

  tree->GetEntry(0);

  for(Int_t tree_idx=0; tree_idx<chain_entries; tree_idx++) {
    tree->GetEntry(tree_idx);
    if((sec%100000)==0)
      continue;
    if(!good)
      continue;
    
    histo->Fill(g_lon);
  }
}

void loop_on_lis(char *list,vector<string> &list_vector) {
  ifstream input_file(list);
  if(!input_file.is_open()) {
    cerr << "\nERROR 100! File not open. The path is:\n" <<list<< "\n\n";
    exit(100);
  }
  string input_string((std::istreambuf_iterator< char >(input_file)), (std::istreambuf_iterator< char >()));
  input_file.close();
  istringstream input_stream(input_string);
  


}

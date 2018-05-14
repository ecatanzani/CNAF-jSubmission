#include "MyHead.h"

void read_SBI_data(Float_t &g_lat,Float_t &g_lon,Float_t &geo_lat,Float_t &geo_lon,Float_t sat_ra[],Float_t sat_dec[],UInt_t &sec,UShort_t &n_ev,bool &good,TChain* tree,std::string j1_line) {
    
    Bool_t chain_single_tree_check=true;
    Int_t chain_entries=(Int_t)tree->GetEntries(),bad_tree_number=-1;
    
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
        if(tree->GetTreeNumber()==bad_tree_number) {
            chain_single_tree_check=false;
            break;
        }
    }
    
    if(!chain_single_tree_check) {
        std::cout<<"\nError loading SBI data !!!"<<std::endl<<std::endl;
        exit(-1);
    }
}

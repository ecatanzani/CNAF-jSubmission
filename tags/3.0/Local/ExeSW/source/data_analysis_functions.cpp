#include "MyHead.h"

void process_file(TH1D *histo,std::string j1_line) {
    
    Float_t g_lat = 0,g_lon = 0,geo_lat = 0,geo_lon = 0,sat_ra[3],sat_dec[3];
    UInt_t sec = 0;
    UShort_t n_ev = 0;
    bool good = true;
    Int_t chain_entries;
    
    TChain *tree= new TChain("SBItree");
    
    read_SBI_data(g_lat,g_lon,geo_lat,geo_lon,sat_ra,sat_dec,sec,n_ev,good,tree,j1_line);
    chain_entries=tree->GetEntries();
    
    for(Int_t tree_idx=0; tree_idx<chain_entries; tree_idx++) {
        tree->GetEntry(tree_idx);
        if((sec%100000)==0)
            continue;
        if(!good)
            continue;
        
        histo->Fill(g_lon);
    }
}


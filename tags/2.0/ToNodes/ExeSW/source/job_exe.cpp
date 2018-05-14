////////////////////////////// Jox exe file
//
//
//
//
//////////////////////////////////////////////////////////////////////////

#include "MyHead.h"

int main(int argc, char* argv[]) {
    
    std::vector<std::string> input_BATCH_files;
    std::string f_name;

    loop_on_list(argv[1],input_BATCH_files);
    get_name(input_BATCH_files.at(0),f_name);
  
    TFile *out_file = new TFile(f_name.c_str(),"RECREATE");
    if(out_file->IsZombie()) {
        std::cout<<"\n\n ERROR writing the output ROOT file \n\n";
        exit(-1);
    }
    TH1D *histo = new TH1D("histo","histo",1000,-180,180);
    for(unsigned int idx_f=0; idx_f<input_BATCH_files.size(); idx_f++)
        process_file(histo,input_BATCH_files.at(idx_f));
    
    out_file->Write();
  
    return 0;
}



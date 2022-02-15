#include <iostream>
#include <stdio.h>
#include<stdlib.h>
#include <string>
#include<fstream>
#include <sstream>
#include <vector>
using namespace std;


int main(int argc, char* argv[])
{
	/* This is the front end of your project.
	You need to first read the instructions that are stored in a file and load them into an instruction memory.
	*/
	//cout << "hey" << endl;
	//creating a set of compatible instructions for the processor
	vector<string> instr{ "addi","lui" ,"li","lw","sw","sb","sh","add", "sub","bltu","blt","bgeu","bge", "beq","bne", "or","ori","xor","xori", "slli","srli", "and","andi", "ori","srai","slai","j","jalr", "lb", "lh", "slti", "sltiu","auipc", "srl","sll", "slt", "sltu","sll", "lbu","lhu" };
	//cout << instr.size() << endl;
	//creating two output files, one for just compatible instructions one for all instructions but noting which ones were parched
	std::ofstream outfile("multparsed.txt");
	string filename = "multparsedall.txt";

	ofstream outputFile;

	outputFile.open(filename.c_str());
	


	
	

	if (argc > 1) {
		//cout << "argv[1] = " << argv[1] << endl;
	}
	else {
		//cout << "No file name entered. Exiting...";
		return -1;
	}
	ifstream infile(argv[1]); //open the file (txt file that you choose as argument
	int i = 0;
	if (infile.is_open() && infile.good()) {
		//cout << "File is now open!\nContains:\n";
		string line = "";
		while (getline(infile, line)) {
			//cout << line[] << '\n';
			if (line.size() >= 9 && line[7] == ' ') //edit line to format it in proper way
			{
				line = line.substr(8);
			}
			else//if not  of correct instruction put in in file that shows all labels and globalsw
			{
				outfile << line << endl;
				cout << line << endl;
				continue;
			}
		
			
			string firstWord = line.substr(0, line.find(" ")); //find the first word in lines that have instructions
		
			stringstream line2(line);
			
			//cout << firstWord << endl;
			if (find(instr.begin(), instr.end(), firstWord) != instr.end()) //if instruction is compatible output it to first file otherwise the second with "parsed" label
			{
				outfile << line << endl;
				outputFile << line << endl;
				cout << line << endl;
			}
			else
			{
				
				outputFile <<"PARSED: " << line << endl;
			}
			//cout << "bits:"<< bitset<8>(x) << endl;

			// << "copying instMem:" << instMem[i] << endl;
			i++;
		}

	}
	else {
		cout << "Failed to open file..";
	}
	//close files
	outputFile.close();
	outfile.close();
	return 0;
}
sparport = struct(); %start with empty sparport struct

%parallel port codes for running SPOTT with BIOPAC psychophys
sparport.parportduration = .002; %send port signals for 2ms (should be caught by BIOPAC at 1kHz acquisition rate)

%start and end of experiment
sparport.parportcodes.expstart = 1; %done
sparport.parportcodes.expend = 2;

%start and end of each part -- note this does not include instructions
sparport.parportcodes.startp1 = 11; %done
sparport.parportcodes.endp1 = 12; %done
sparport.parportcodes.startp2 = 21; %done
sparport.parportcodes.endp2 = 22; %done
sparport.parportcodes.startp3 = 31; %done
sparport.parportcodes.endp3 = 32; %done
sparport.parportcodes.startp4 = 41; %done
sparport.parportcodes.endp4 = 42; %done


%part 1
sparport.parportcodes.p1stimonset = 13; %done
sparport.parportcodes.p1actionchosen = 14;%done
sparport.parportcodes.p1feedback = 15;%done

%part 2
sparport.parportcodes.p2stimonset = 23; %done
sparport.parportcodes.p2usonset = 24; %done
sparport.parportcodes.p2usonly = 25; %done
sparport.parportcodes.p2itionset = 26; %done

%part 3
sparport.parportcodes.p3csonset = 33; %done
sparport.parportcodes.p3stimonset = 34; %done
sparport.parportcodes.p3choice= 35; %done
sparport.parportcodes.p3feedback = 36; %done
sparport.parportcodes.p3itionset = 37; %done

%part 4
sparport.parportcodes.p4stimAonset = 43; %done
sparport.parportcodes.p4stimBonset = 44; %done
sparport.parportcodes.p4dualonset = 45; %done
sparport.parportcodes.p4choice = 46; %done

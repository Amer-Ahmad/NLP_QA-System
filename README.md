# NLP_QA-System
Question Answering System for Natural Language Processing


#Kyle Sutherland
#CMSC 416
#4/16/17

#This program runs in the format:
#     perl qa-system.pl mylogfile.txt
# where mylogfile.txt is an output log file

#This is a question answering system.  It uses wikipedia to search for topics
#and answer questions.  Questions should come in the format: 
#    "Who|What|When|Where _____________?"
#It then splits the question into pieces and polls wikipedia to return the 
#answer.  It captures the type of question to find out what to search the 
#wikipedia article for, comes up with an answer based on what the question type 
#and any extra information, then the answer is and then reformats the answer 
#into natural language.  The answer is then printed to STDOUT.  The question, 
#wiki text, and concluded answer are all recorded in the log file.


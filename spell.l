%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#define MAX_WORD_LEN 100
int is_correct_word(const char *word);
void to_lowercase(char *dest, const char *src);
%}
%option noyywrap
%%
[a-zA-Z]+ { 
    if (!is_correct_word(yytext)) 
        printf("Misspelled: %s\n", yytext); 
}
.         {}
\n        {}
%%
void to_lowercase(char *dest, const char *src){
    while (*src) {
        *dest++ = tolower(*src++);
    }
    *dest = '\0';
}

int is_correct_word(const char *word){
    FILE *dict = fopen("dictionary.txt", "r");
    if (!dict) {
        printf("Error: Dictionary file not found\n");
        return 1;
    }
    char dict_word[MAX_WORD_LEN];
    char lower_word[MAX_WORD_LEN];
    char lower_dict[MAX_WORD_LEN];
    
    to_lowercase(lower_word, word);
    
    while (fgets(dict_word, sizeof(dict_word), dict)) {
        char *end = dict_word + strlen(dict_word) - 1;
        while (end >= dict_word && isspace(*end)) {
            *end = '\0';
            end--;
        }
        
        to_lowercase(lower_dict, dict_word);
        if (strcmp(lower_word, lower_dict) == 0) {
            fclose(dict);
            return 1;
        }
    }
    fclose(dict);
    return 0;
}

int main(){
    yylex();
    return 0;
}

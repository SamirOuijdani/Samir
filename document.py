"""
Samir Ouijdani
Section AD
"""
import re


class Document:
    """
    The Document class represents the data
    in a single web page and includes methods
    to compute term frequency.
    """

    def __init__(self, path):
        """
        initializes the document class
        """
        self._dictionairy = {}
        self.path = path
        with open(path) as f:
            lines = f.readlines()
            for line in lines:
                tokens = line.split()
                for token in tokens:
                    token = token.lower()
                    token = re.sub(r'\W+', '', token)
                    if token not in self._dictionairy:
                        self._dictionairy[token] = 1
                    else:
                        self._dictionairy[token] += 1
            wordcount = sum(self._dictionairy.values(), 0.0)
            self._dictionairy = {k: v / wordcount for k,
                                 v in self._dictionairy.items()}

    def get_path(self):
        """
        returns the path of the file
        """
        return self.path

    def term_frequency(self, term):
        """
        calculates the term frequency for a given term
        """
        term = term.lower()
        term = re.sub(r'\W+', '', term)
        self.term = term
        if self.term not in self._dictionairy.keys():
            return 0
        else:
            return self._dictionairy.get(term)

    def get_words(self):
        """
        returns a list of the unique, normalized
        words in this document.
        """
        return [*self._dictionairy]

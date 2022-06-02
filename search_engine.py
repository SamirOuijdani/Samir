"""
Samir Ouijdani
Section AD

"""
import os
import re
import math
from operator import itemgetter
from document import Document


class SearchEngine:
    """
    The SearchEngine class classifies
    search terms as well as provides a
    command-line interface
    """
    def __init__(self, directory):
        """
        initializes the search engine class
        """
        self._inverse_index = {}
        self._file_names = os.listdir(directory)

        for i in range(0, len(self._file_names)):
            path = os.path.join(directory, self._file_names[i])
            document = Document(path)
            for j in document.get_words():
                if j not in self._inverse_index:
                    self._inverse_index[j] = [document]
                else:
                    self._inverse_index[j].append(document)

    def _calculate_idf(self, term):
        """
        calculates the inverse document frequency
        """
        term = term
        term = re.sub(r'\W+', '', term)
        if term not in (self._inverse_index):
            return 0
        else:
            num_doc = len(self._file_names)
            num_term = len(self._inverse_index.get(term))
            idf = math.log((num_doc / num_term))
            return idf

    def search(self, query):
        """
        normalizes the search query and
        creates a corpus of documents that
        match up with the query.
        """
        query = query.lower()
        query = query.split()
        document_set = set()
        tuple_list = []
        return_list = []
        terms_counted = 0
        tf = 0
        idf = 0
        tf_idf = 0
        while terms_counted < len(query):
            query[terms_counted] = re.sub(r'\W+', '', query[terms_counted])
            terms_counted += 1
        for keys, values in self._inverse_index.items():
            for term in query:
                if keys == term:
                    for value in values:
                        document_set.add(value)
        for doc in document_set:
            for term in query:
                single_doc_list = []
                idf = self._calculate_idf(term)
                tf = (doc.term_frequency(term))
                tf_idf = tf * idf
                single_doc_list.append(tf_idf)
            for keys in single_doc_list:
                tuple_list.append([doc, keys])
        tuple_list.sort(key=itemgetter(1), reverse=True)
        for i in tuple_list:
            return_list.append(i[0].get_path())
        return(return_list)

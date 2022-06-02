"""
Samir Ouijdani
Section AD
This file tests the output
from the document and search
engine classes
"""
from cse163_utils import assert_equals

from document import Document
from search_engine import SearchEngine

Document = Document('/home/tester.txt')
SearchEngine = SearchEngine('/home/directorytest')
assert_equals((7/20), Document.term_frequency('Cat.'))
assert_equals(('/home/tester.txt'), Document.get_path())
assert_equals((['this', 'is', 'some', 'text', 'that', 'i',
                'am', 'going', 'to', 'search', 'cat']), Document.get_words())


assert_equals((['/home/directorytest/testsearch.txt',
                '/home/directorytest/onemore.txt']),
              SearchEngine.search('cat'))
assert_equals((['/home/directorytest/testsearch2.txt',
                '/home/directorytest/testsearch.txt']),
              SearchEngine.search('dog'))
assert_equals((0.4054651081081644), SearchEngine._calculate_idf('dog'))


def main():
    print()


if __name__ == '__main__':
    main()

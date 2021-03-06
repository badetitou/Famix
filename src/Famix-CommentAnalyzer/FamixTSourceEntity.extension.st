Extension { #name : #FamixTSourceEntity }

{ #category : #'*Famix-CommentAnalyzer' }
FamixTSourceEntity >> commentedCodeComments [
	^ self comments select: #isCode
]

{ #category : #'*Famix-CommentAnalyzer' }
FamixTSourceEntity >> commentedCodeCommentsIntervals [
	^ self commentedCodeComments collect: [ :aComment | aComment sourceAnchor startPos to: aComment sourceAnchor endPos ]
]

{ #category : #'*Famix-CommentAnalyzer' }
FamixTSourceEntity >> commentedCodeCommentsPercentage [
	<FMProperty: #commentedCodeCommentsPercentage type: #Number>
	<derived>
	<FMComment: 'The percentage of commented code in a program'>
	^ self
		propertyNamed: #commentedCodeCommentsPercentage
		ifAbsentPut: [ [ self commentedCodeCommentsTotalLength / self commentsTotalLength ]
				on: ZeroDivide
				do: [ 0 ] ]
]

{ #category : #'*Famix-CommentAnalyzer' }
FamixTSourceEntity >> commentedCodeCommentsTotalLength [
	^ self commentedCodeComments sumNumbers: #length
]

{ #category : #'*Famix-CommentAnalyzer' }
FamixTSourceEntity >> commentsIntervals [
	^ self comments collect: [ :aComment | aComment sourceAnchor startPos to: aComment sourceAnchor endPos ]
]

{ #category : #'*Famix-CommentAnalyzer' }
FamixTSourceEntity >> commentsRatio [
	<FMProperty: #commentsRatio type: #Number>
	<derived>
	<FMComment: 'The percentage of comments in an entity'>
	^ self propertyNamed: #commentsRatio ifAbsentPut: [ self computeCommentsPercentage ]
]

{ #category : #'*Famix-CommentAnalyzer' }
FamixTSourceEntity >> commentsTotalLength [
	^ self comments sumNumbers: #length
]

{ #category : #'*Famix-CommentAnalyzer' }
FamixTSourceEntity >> computeCommentsPercentage [
	| sourceTextSize |
	
	"If there is no comment, no need to read the sources which is not performant."
	self comments ifEmpty: [ ^ 0 ].
	
	sourceTextSize := self sourceText size.

	"To avoid Zero divide error."
	sourceTextSize = 0 ifTrue: [ ^ 0 ].
	
	^ self commentsTotalLength / sourceTextSize
]

{ #category : #'*Famix-CommentAnalyzer' }
FamixTSourceEntity >> mergedComments [
	^ self cacheAt: #mergedComments ifAbsentPut: [ OrderedCollection new ]
]

{ #category : #'*Famix-CommentAnalyzer' }
FamixTSourceEntity >> mergedComments: collection [
	self cacheAt: #mergedComments put: collection
]

{ #category : #'*Famix-CommentAnalyzer' }
FamixTSourceEntity >> numberOfCommentLines [
	^ self comments sumNumbers: [ :comment | comment lines size ]
]

{ #category : #'*Famix-CommentAnalyzer' }
FamixTSourceEntity >> numberOfUsefulCommentLines [
	^ self usefulComments sumNumbers: [ :comment | comment lines size ]
]

{ #category : #'*Famix-CommentAnalyzer' }
FamixTSourceEntity >> sourceCommentRateWithCleaning [
	^ self cacheAt: #sourceCommentRateWithCleaning ifAbsentPut: [ self sourceCommentRateWithSelector: #sourceCommentRateWithCleaning ]
]

{ #category : #'*Famix-CommentAnalyzer' }
FamixTSourceEntity >> sourceCommentRateWithSelector: aSelector [
	self isContainerEntity ifFalse: [ self error: 'This metric makes sense only for containers.' ].
	^ self children asOrderedCollection
		ifEmpty: [ 1 ]
		ifNotEmpty: [ | lambda |
			lambda := 9.
			((self children asMooseGroup average: [ :func | lambda raisedTo: (func perform: aSelector) negated ]) log: lambda) negated round: 3 ]
]

{ #category : #'*Famix-CommentAnalyzer' }
FamixTSourceEntity >> sourceCommentRateWithoutCleaning [
	^ self cacheAt: #sourceCommentRateWithoutCleaning ifAbsentPut: [ self sourceCommentRateWithSelector: #numberOfCommentLines ]
]

{ #category : #'*Famix-CommentAnalyzer' }
FamixTSourceEntity >> usefulComments [
	^ FamixCAAnalyzer findUsefulCommentsIn: self
]

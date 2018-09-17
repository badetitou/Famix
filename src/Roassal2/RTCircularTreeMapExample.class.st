"
RTCircularTreeMapExample new installTitle: 'FileSystem' 
		code:
		'

| b color |
b := RTCircularTreeMapBuilder new.
color := RTScale linear 
	domain: { 0. 12000.};
	range: { Color gray. Color red }.
b shape
	color: Color transparent;
	borderColor: Color black;
	if: [ :f | f isFile ] color: [ :f | color scale: f size sqrt ].
b 
	leafWeight: [:f | f size sqrt ]; 
	explore: FileSystem disk workingDirectory
	nesting: #directories
	leaves: #files.
b build.
^ b view'
	
"
Class {
	#name : #RTCircularTreeMapExample,
	#superclass : #RTAbstractExample,
	#category : #'Roassal2-Builder-CircularMap'
}

{ #category : #sources }
RTCircularTreeMapExample >> example01 [

	| b mt |
	b := RTCircularTreeMapBuilder new.
	b shape
		color: Color transparent.
	b
		baseradius: 200;
		weight: 1.
	mt := TRPlatform current morphClass.
	b explore: mt
		using: #subclasses.
	
	b build.
	^ b view
]

{ #category : #icons }
RTCircularTreeMapExample >> example01Icon [
	^ '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'
]

{ #category : #sources }
RTCircularTreeMapExample >> example02 [

| b |
	b := RTCircularTreeMapBuilder new.
	b shape
		color: Color transparent.
	b
		baseradius: 400;
		weight: [:n | n].
	b explore: 1
		using: [:n | n< 3 ifTrue: [Array with: n+1 with: n+2] ifFalse: [ #() ] ].
	
	b build.
	^ b view
]

{ #category : #icons }
RTCircularTreeMapExample >> example02Icon [
	^ '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
aQEYAAAAAElFTkSuQmCC'
]

{ #category : #sources }
RTCircularTreeMapExample >> example03 [

	
	| b  |
	b := RTCircularTreeMapBuilder new.
	
	b shape
		color: Color transparent;
		borderColor: Color black;
		if: [ :cls | cls subclasses isEmpty ] fillColor: [ :cls| 
			(Smalltalk includesKey: (cls name, 'Test') asSymbol) ifTrue: [ Color green ]
			ifFalse: [ Color purple ] ].
	b
		baseradius: 200;
		weight: [ :cls | cls withAllSubclasses size].
	b explore: RTObject
		using: #subclasses.
	
	b build.
	^ b view
]

{ #category : #icons }
RTCircularTreeMapExample >> example03Icon [
	^ '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
IQHCkVeSAAAAAElFTkSuQmCC'
]

{ #category : #sources }
RTCircularTreeMapExample >> exampleClassHierarchy [

| b  |
b := RTCircularTreeMapBuilder new.

b
	baseradius: 200;
	weight: [ :cls | cls withAllSubclasses size].

b explore: Collection 
	using: #subclasses.

b build.
	^ b view
]

{ #category : #icons }
RTCircularTreeMapExample >> exampleClassHierarchyIcon [
	^ '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
T/62FQl3AAAAAElFTkSuQmCC'
]

{ #category : #sources }
RTCircularTreeMapExample >> exampleColoredSubclasses [
| p b |

p := RTPalette c6.
b := RTCircularTreeMapBuilder new.

b shape
	color: p second;
	if: [ :cls | '*Array*' match: cls name ] fillColor: [ p first ];
	if: [ :cls | '*Dictionary*' match: cls name ] fillColor: [ p third ];
	if: [ :cls | '*Identity*' match: cls name ] fillColor: [ p fourth ];
	if: [ :cls | '*Set*' match: cls name ] fillColor: [ p fifth ].
b
	baseradius: 200;
	weight: [ :cls | cls withAllSubclasses size].

b explore: Collection 
	using: #subclasses.

b build.
	^ b view
]

{ #category : #icons }
RTCircularTreeMapExample >> exampleColoredSubclassesIcon [
	^ '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'
]

{ #category : #accessing }
RTCircularTreeMapExample >> label [
	^ 'Circular Tree map'
]
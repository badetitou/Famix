"
Description
-------------------

I am an object reponsible for the computation of a query. I am here to hide the implementations of queries to the entities. 

For more informations: https://moosequery.ferlicot.fr/

Examples
-------------------
	
	(MooseQueryCalculator direction: #in) query: FAMIXInvocation for: aMethod.
	
	(MooseQueryCalculator strategy: MooseQueryOutgoingDirectionStrategy) queryAllLocalFor: aMethod.
	
	(MooseQueryCalculator strategy: MooseQueryIncomingDirectionStrategy) query: FAMIXInvocation for: aMethod.
 
Internal Representation and Key Implementation Points.
-------------------

    Instance Variables
	strategy:		<aMooseQueryDirectionStrategy> 		A strategy responsible of the behavior depending on the direction of the association


"
Class {
	#name : #MooseQueryNavigationQuery,
	#superclass : #Object,
	#instVars : [
		'strategy'
	],
	#category : #'Moose-Query-Navigating'
}

{ #category : #'instance creation' }
MooseQueryNavigationQuery class >> direction: aSymbol [
	^ self strategy: (MooseQueryAbstractDirectionStrategy fromSymbol: aSymbol)
]

{ #category : #'instance creation' }
MooseQueryNavigationQuery class >> strategy: aStrategy [
	^ self new
		strategy: aStrategy;
		yourself
]

{ #category : #query }
MooseQueryNavigationQuery >> has: aFAMIXClassAssociation for: anEntity [
	"I know that we could use #do: here, but this algo takes too long on big model, so this is a speed up while the sista vm is not ready for production"

	| selectors |
	(self hasLocal: aFAMIXClassAssociation for: anEntity)
		"End condition"
		ifTrue: [ ^ true ].
	1 to: (selectors := anEntity childrenSelectors) size do: [ :index | 
		(anEntity perform: (selectors at: index))
			ifNotNil: [ :children | 
				| coll |
				1 to: (coll := children asCollection) size do: [ :i | 
					(self has: aFAMIXClassAssociation for: (coll at: i))
						ifTrue: [ ^ true ] ] ] ].
	^ false
]

{ #category : #query }
MooseQueryNavigationQuery >> hasFor: anEntity [
	| selectors |
	(self hasLocalFor: anEntity) ifTrue: [ ^ true ].
	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to: (selectors := anEntity childrenSelectors) size do: [ :index | 
		(anEntity perform: (selectors at: index))
			ifNotNil: [ :children | 
				| coll |
				1 to: (coll := children asCollection) size do: [ :i | (self hasFor: (coll at: i)) ifTrue: [ ^ true ] ] ] ].
	^ false
]

{ #category : #query }
MooseQueryNavigationQuery >> hasLocal: aFAMIXClassAssociation for: anEntity [
	"The goal here is to get all the entity's direct associations of the class in parameter. This will not check the associations of the entity's children."

	"Note: Maybe adding a guard to check if the entity can have associations of this class could improve the perf. Currently it is not the case because there is not enough association. Maybe it could be the case in the futur, like with a PostgreSQL model."

	| properties |
	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to: (properties := self strategy msePropertiesOf: anEntity) size
	do: [ :ind | 
		(anEntity perform: (properties at: ind) name)
			ifNotNil: [ :coll | 
				coll asCollection
							do: [ :each | (each isOfType: aFAMIXClassAssociation) ifTrue: [ ^ true ] ] ] ].
	^ false
]

{ #category : #query }
MooseQueryNavigationQuery >> hasLocalFor: anEntity [
	"The goal here is to get all the entity's direct associations of the class in parameter. This will not check the associations of the entity's children."

	"Note: Maybe adding a guard to check if the entity can have associations of this class could improve the perf. Currently it is not the case because there is not enough association. Maybe it could be the case in the futur, like with a PostgreSQL model."

	| properties |
	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to: (properties := self strategy msePropertiesOf: anEntity) size
	do: [ :ind | 
		(anEntity perform: (properties at: ind) name)
			ifNotNil: [ :coll | 
				 coll asCollection ifNotEmpty: [ ^ true ] ] ].
	^ false
]

{ #category : #query }
MooseQueryNavigationQuery >> query: aFAMIXClassAssociation for: anEntity [
	^ self strategy
		queryResultOn: anEntity
		with: (self query: aFAMIXClassAssociation for: anEntity in: OrderedCollection new) asSet
]

{ #category : #query }
MooseQueryNavigationQuery >> query: aFAMIXClassAssociation for: anEntity in: aCollection [
	"I know that we could use #do: here, but this algo takes too long on big model, so this is a speed up while the sista vm is not ready for production"

	| selectors |
	self queryLocal: aFAMIXClassAssociation for: anEntity in: aCollection.
	1 to: (selectors := anEntity childrenSelectors) size do: [ :index | 
		(anEntity perform: (selectors at: index))
			ifNotNil: [ :children | 
				| coll |
				1 to: (coll := children asCollection) size do: [ :i | self query: aFAMIXClassAssociation for: (coll at: i) in: aCollection ] ] ].
	^ aCollection
]

{ #category : #query }
MooseQueryNavigationQuery >> queryAllFor: anEntity [
	^ self strategy queryResultOn: anEntity with: (self queryAllFor: anEntity in: OrderedCollection new) asSet
]

{ #category : #query }
MooseQueryNavigationQuery >> queryAllFor: anEntity in: aCollection [
	"collects in aCollection all entities on the opposite side of associations with self
	 Opposite side depends on self strategy (incoming/outgoing)
	
	First collects entities from local (not inherited) properties
	Then get children entities of self and applies recurvively on them"
	| selectors |
	self queryAllLocalFor: anEntity in: aCollection.
	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to: (selectors := anEntity childrenSelectors) size do: [ :index | 
		(anEntity perform: (selectors at: index))
			ifNotNil: [ :children | 
				| coll |
				1 to: (coll := children asCollection) size do: [ :i | self queryAllFor: (coll at: i) in: aCollection ] ] ].
	^ aCollection
]

{ #category : #query }
MooseQueryNavigationQuery >> queryAllLocalFor: anEntity [

	^ self strategy queryResultOn: anEntity with: (self queryAllLocalFor: anEntity in: OrderedCollection new) asSet
]

{ #category : #query }
MooseQueryNavigationQuery >> queryAllLocalFor: anEntity in: aCollection [
	"collects in aCollection all entities on the opposite side of associations or declared dependencies with self
	 Opposite side depends on self strategy (incoming/outgoing)
	
	First collects local (not inherited) properties that match the strategy
	Then applies these properties to find entities associated to self"

	| properties |
	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to: (properties := self strategy msePropertiesOf: anEntity) size do: [ :ind | 
		(anEntity perform: (properties at: ind) name)
			ifNotNil: [ :coll | coll asCollection do: [ :res | aCollection add: (self strategy ensureAssociation: res with: anEntity) ] ] ].
	^ aCollection
]

{ #category : #query }
MooseQueryNavigationQuery >> queryLocal: aFAMIXClassAssociation for: anEntity [

	^ self strategy queryResultOn: anEntity with: (self queryLocal: aFAMIXClassAssociation for: anEntity in: OrderedCollection new) asSet
]

{ #category : #query }
MooseQueryNavigationQuery >> queryLocal: aFAMIXClassAssociation for: anEntity in: aCollection [
	"The goal here is to get all the entity's direct associations of the class in parameter. This will not check the associations of the entity's children."

	"Note: Maybe adding a guard to check if the entity can have associations of this class could improve the perf. Currently it is not the case because there is not enough association. Maybe it could be the case in the futur, like with a PostgreSQL model."

	| properties |
	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to: (properties := self strategy msePropertiesOf: anEntity) size do: [ :ind | 
		(anEntity perform: (properties at: ind) name)
			ifNotNil: [ :coll | aCollection addAll: (coll asCollection select: [ :each | each isOfType: aFAMIXClassAssociation ]) ] ].
	^ aCollection
]

{ #category : #query }
MooseQueryNavigationQuery >> source: aFAMIXClassAssociation for: anEntity [ 
	^ self strategy
		queryResultOn: anEntity
		with: (self source: aFAMIXClassAssociation for: anEntity in: OrderedCollection new) asSet
]

{ #category : #query }
MooseQueryNavigationQuery >> source: aFAMIXClassAssociation for: anEntity in: aCollection [
	| selectors |
	self sourceLocal: aFAMIXClassAssociation for: anEntity in: aCollection.
	1 to: (selectors := anEntity childrenSelectors) size do: [ :index | 
		(anEntity perform: (selectors at: index))
			ifNotNil: [ :children | 
				| coll |
				1 to: (coll := children asCollection) size do: [ :i | self through: aFAMIXClassAssociation for: (coll at: i) in: aCollection ] ] ].
	^ aCollection
]

{ #category : #accessing }
MooseQueryNavigationQuery >> strategy [
	^ strategy
]

{ #category : #accessing }
MooseQueryNavigationQuery >> strategy: anObject [
	strategy := anObject
]

{ #category : #query }
MooseQueryNavigationQuery >> through: aFAMIXClassAssociation for: anEntity [ 
	^ self strategy
		queryResultOn: anEntity
		with: (self through: aFAMIXClassAssociation for: anEntity in: OrderedCollection new) asSet
]

{ #category : #query }
MooseQueryNavigationQuery >> through: aFAMIXClassAssociation for: anEntity in: aCollection [
	| selectors |
	self throughLocal: aFAMIXClassAssociation for: anEntity in: aCollection.
	1 to: (selectors := anEntity childrenSelectors) size do: [ :index | 
		(anEntity perform: (selectors at: index))
			ifNotNil: [ :children | 
				| coll |
				1 to: (coll := children asCollection) size do: [ :i | self through: aFAMIXClassAssociation for: (coll at: i) in: aCollection ] ] ].
	^ aCollection
]

{ #category : #query }
MooseQueryNavigationQuery >> throughAllFor: anEntity [
	^ self strategy queryResultOn: anEntity with: (self throughAllFor: anEntity in: OrderedCollection new) asSet
]

{ #category : #query }
MooseQueryNavigationQuery >> throughAllFor: anEntity in: aCollection [
	| selectors |
	self throughAllLocalFor: anEntity in: aCollection.
	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to: (selectors := anEntity childrenSelectors) size do: [ :index | 
		(anEntity perform: (selectors at: index))
			ifNotNil: [ :children | 
				| coll |
				1 to: (coll := children asCollection) size do: [ :i | self throughAllFor: (coll at: i) in: aCollection ] ] ].
	^ aCollection
]

{ #category : #query }
MooseQueryNavigationQuery >> throughAllLocalFor: anEntity [

	^ self strategy queryResultOn: anEntity with: (self throughAllLocalFor: anEntity in: OrderedCollection new) asSet
]

{ #category : #query }
MooseQueryNavigationQuery >> throughAllLocalFor: anEntity in: aCollection [
	| properties |
	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."
	1 to: (properties := self strategy msePropertiesOf: anEntity) size do: [ :ind | 
		(anEntity perform: (properties at: ind) name)
			ifNotNil:
				[ :coll | coll asCollection do: [ :res | aCollection add: ((self strategy ensureAssociation: res with: anEntity) perform: self strategy symbolToCollectEntities) ] ] ].
	^ aCollection
]

{ #category : #query }
MooseQueryNavigationQuery >> throughLocal: aFAMIXClassAssociation for: anEntity in: aCollection [
	"The goal here is to get all the entity's direct associations of the class in parameter. This will not check the associations of the entity's children."
	
	"Note: Maybe adding a guard to check if the entity can have associations of this class could improve the perf. Currently it is not the case because there is not enough association. Maybe it could be the case in the futur, like with a PostgreSQL model."
	
	| properties |
	"Instead of #to:do: we could just use #do: but this implementation is much faster. Maybe sista will remove the needs of the todo later."

	properties := (self strategy msePropertiesOf: anEntity) select: [:each |  aFAMIXClassAssociation inheritsFromType: each implementingType ].
	
	
	1 to: properties size do: [ :ind | (anEntity perform: (properties at: ind) name) ifNotNil: [ :coll | aCollection addAll: (coll asCollection select: [ :each | each isOfType: aFAMIXClassAssociation ] thenCollect: [ :each | each perform: self strategy symbolToCollectEntities ] ) ] ].
	^ aCollection
]
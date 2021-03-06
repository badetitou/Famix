Class {
	#name : #AbstractSmalltalkMetamodelFactory,
	#superclass : #FamixBasicInfrastructureMetamodelFactory,
	#category : #'Moose-SmalltalkImporter'
}

{ #category : #testing }
AbstractSmalltalkMetamodelFactory class >> isAbstract [
	^ self = AbstractSmalltalkMetamodelFactory
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> access [

	^ self entityNamed: #Access
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> anchor [

	^ self entityNamed: #PharoEntitySourceAnchor
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> annotationInstance [ 

	^ self entityNamed: #AnnotationInstance
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> annotationInstanceAttribute [

	^ self entityNamed: #AnnotationInstanceAttribute
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> annotationType [

	^ self entityNamed: #AnnotationType
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> annotationTypeAttribute [

	^ self entityNamed: #AnnotationTypeAttribute
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> attribute [

	^ self entityNamed: #Attribute
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> classEntity [

	^ self entityNamed: #Class
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> globalVariable [

	^ self entityNamed: #GlobalVariable
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> implicitVariable [

	^ self entityNamed: #ImplicitVariable
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> inheritance [

	^ self entityNamed: #Inheritance
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> invocation [

	^ self entityNamed: #Invocation
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> localVariable [

	^ self entityNamed: #LocalVariable
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> method [

	^ self entityNamed: #Method
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> namespace [

	^ self entityNamed: #Namespace
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> package [

	^ self entityNamed: #Package
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> parameter [

	^ self entityNamed: #Parameter
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> pharoAnchor [

	^ self entityNamed: #PharoAnchor
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> reference [

	^ self entityNamed: #Reference
]

{ #category : #accessing }
AbstractSmalltalkMetamodelFactory >> unknownVariable [

	^ self entityNamed: #UnknownVariable
]

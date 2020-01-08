Class {
	#name : #BaselineOfHoge,
	#superclass : #BaselineOf,
	#category : #BaselineOfHoge
}

{ #category : #baselines }
BaselineOfHoge >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			spec
				baseline: 'KFImaging'
				with: [ spec repository: 'github://kenjirofukuda/imaging-pharo:Pharo6.1' ].
			spec
				configuration: 'WebBrowser'
				with: [ spec
						versionString: #stable;
						repository: 'http://www.squeaksource.com/Pharo/MetaRepoForPharo60' ].
			spec
				configuration: 'OSProcess'
				with: [ spec
						versionString: #stable;
						repository: 'http://www.squeaksource.com/MetacelloRepository' ].
			spec
				configuration: 'NeoCSV'
				with: [ spec
						versionString: #stable;
						repository: 'http://mc.stfx.eu/Neo' ].
			spec package: #Hoge with: [ spec requires: #('KFImaging' 'OSProcess' 'NeoCSV') ] ]
]

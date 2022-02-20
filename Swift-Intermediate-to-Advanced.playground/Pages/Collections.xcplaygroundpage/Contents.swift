//: [Previous](@previous)

import Foundation

class Audio {
    
    var name:String
    var processTime:Date
    
    init(name:String){
        self.name = name
        self.processTime = Date()
    }
    
    func getname() -> String {
        return self.name
    }
}



struct AudioSequence: Sequence{
    
    let audioList:[String]
    let itercount:Int
    let batch:Int
    let warmupCount:Int
    
    func makeIterator() ->  AudioIterator {
        return AudioIterator(self)
    }
}

struct AudioIterator: IteratorProtocol {
    
    let seq: AudioSequence
    var current:Int = 0
    var maxCount:Int = 0
    
    init(_ audioSeq: AudioSequence) {
        self.seq = audioSeq
        self.current = 0
        self.maxCount = audioSeq.batch
        
    }
    
    mutating func next() -> Audio? {
    
        if seq.itercount == 0 {
            if current < seq.warmupCount {
                var value = current
                current+=1
                return Audio(name:seq.audioList[value])
            } else {
                return nil
            }
        }else{
            if current < maxCount {
                var value = current + seq.batch*(seq.itercount-1)
                current+=1
                return Audio(name:seq.audioList[value])
            } else {
                return nil
            }
        }
        return nil
       
    }
        
}


let utterances = ["a.wav","b.wav","c.wav","d.wav","e.wav",
                  "f.wav","g.wav","h.wav","i.wav","j.wav"]

for iter in 0...2{
    for i in AudioSequence(audioList:utterances,itercount:iter,batch:5,warmupCount: 3) {
        print(i.getname())
    }
    print("----------------")
}

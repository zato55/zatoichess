import crypto from 'node:crypto';
const oldSecret='v65-old-secret'; const newSecret='v65-new-secret'; const payload='zato-v65-export-integrity';
const sign=(secret,input)=>crypto.createHmac('sha256',secret).update(input).digest('hex');
const oldSig=sign(oldSecret,payload), newSig=sign(newSecret,payload);
if(oldSig===newSig) throw new Error('V65 rotation harness: signatures unexpectedly equal');
if(!crypto.timingSafeEqual(Buffer.from(newSig),Buffer.from(sign(newSecret,payload)))) throw new Error('V65 rotation harness: new key verification failed');
if(crypto.timingSafeEqual(Buffer.from(oldSig),Buffer.from(sign(newSecret,payload)))) throw new Error('V65 rotation harness: retired key incorrectly verified');
console.log('V65 signature rotation harness OK');

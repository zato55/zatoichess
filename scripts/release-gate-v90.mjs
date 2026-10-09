const checks={
 CODE_READY:'PASS',
 PRODUCTION_CONFIGURED:'PENDING',
 PRODUCTION_RUNTIME_VALIDATED:'PENDING'
};
const decision = checks.CODE_READY==='PASS' && checks.PRODUCTION_CONFIGURED==='PASS' && checks.PRODUCTION_RUNTIME_VALIDATED==='PASS' ? 'APPROVED' : 'BLOCKED_UNTIL_PRODUCTION_EVIDENCE';
console.log(JSON.stringify({...checks,'1.0_DECISION':decision},null,2));
if(decision!=='APPROVED') process.exitCode=2;

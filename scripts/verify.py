#!/usr/bin/env python3
"""Build every project theorem, print its axioms, and reject proof escapes."""
from pathlib import Path
import hashlib,json,re,subprocess
root=Path(__file__).resolve().parents[1]
def code_only(text):
 out=[];i=0;depth=0;string=False
 while i<len(text):
  if depth:
   if text.startswith('/-',i):depth+=1;i+=2
   elif text.startswith('-/',i):depth-=1;i+=2
   else:out.append('\n' if text[i]=='\n' else ' ');i+=1
  elif string:
   if text[i]=='\\':i+=2
   elif text[i]=='"':string=False;i+=1
   else:i+=1
  elif text.startswith('/-',i):depth=1;i+=2
  elif text.startswith('--',i):
   end=text.find('\n',i);i=len(text) if end<0 else end
  elif text[i]=='"':string=True;i+=1
  else:out.append(text[i]);i+=1
 return ''.join(out)
files=sorted((root/'ExactNN').glob('*.lean'));names=[]
for path in files:
 text=code_only(path.read_text())
 banned=re.findall(r'\b(?:sorry|admit|axiom|sorryAx|native_decide|unsafe)\b',text)
 if banned:raise SystemExit(f'{path.name}: forbidden proof escapes: {banned}')
 names+=['ExactNN.'+s for s in re.findall(r'\btheorem\s+([\w.]+)',text)]
if len(set(names))!=len(names):raise SystemExit('Duplicate theorem names')
(root/'Audit.lean').write_text('import ExactNN\n\n'+''.join(f'#print axioms {n}\n' for n in names))
(root/'verification').mkdir(exist_ok=True)
def run(args,name):
 proc=subprocess.run(args,cwd=root,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 (root/'verification'/name).write_text(proc.stdout)
 print(proc.stdout,flush=True)
 if proc.returncode:raise SystemExit(proc.returncode)
 return proc.stdout
run(['lean','--version'],'toolchain.txt')
run(['lake','build'],'build.log')
output=run(['lake','env','lean','Audit.lean'],'axioms.log')
allowed={'propext','Classical.choice','Quot.sound'}
results=re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]",output,re.S)
noaxioms=re.findall(r"'([^']+)' does not depend on any axioms",output)
seen={n for n,_ in results}|set(noaxioms)
if seen!=set(names):raise SystemExit(f'Audit mismatch: missing {set(names)-seen}, extra {seen-set(names)}')
for name,axioms in results:
 ax={a.strip() for a in axioms.split(',') if a.strip()}
 if ax-allowed:raise SystemExit(f'{name}: nonstandard axioms: {ax-allowed}')
report={'theorems':len(names),'modules':len(files),'build_exit_code':0,'axiom_audit_exit_code':0,
 'permitted_foundational_axioms':sorted(allowed),
 'source_sha256':{str(p.relative_to(root)):hashlib.sha256(p.read_bytes()).hexdigest() for p in files},
 'scope':'Only the listed declarations; no unconditional P = exists R theorem is claimed.'}
(root/'verification/summary.json').write_text(json.dumps(report,indent=2)+'\n')
print(f'PASS: {len(names)} project theorems built and axiom-audited.',flush=True)

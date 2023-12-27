
"""  By Rossana Suarez
     Roxs Security-tools
     python roxs-security-tools horusec.json horusec
  """

import sys
import os
import json

RED = '\033[91m'
RESET = '\033[0m'

def print_color(message, color):
    sys.stdout.write(color + message  + '\n')
    sys.stdout.flush()

def severity(severity):
    severity = severity.upper()
    if (severity == 'ERROR'):
        return 'HIGH'
    if (severity == 'WARNING' or severity == 'UNKNOWN' or severity == 'MODERATE'):
        return "MEDIUM"
    if (severity == 'INFO'):
        return 'LOW'    
    return severity

exitCode = 0
vulnerabilities = []
fileInput = sys.argv[1]
tool = sys.argv[2]

if (os.path.isfile(fileInput)):
        allow_failure = True
with open(fileInput, 'r') as f:
        issues_dict = json.load(f)

if tool == 'horusec':
        try:
            if issues_dict['analysisVulnerabilities'] is not None:
                for issue in issues_dict['analysisVulnerabilities']:
                    issue['vulnerabilities']["severity"] = severity(issue['vulnerabilities']["severity"])
                    vulnerabilities.append(issue)
        except Exception:
            print("")   
if tool == 'trivy':
    try:
        if issues_dict['Results'] is not None:
            for result in issues_dict['Results']:
                vulnerabilities.extend(result['Vulnerabilities'])
    except Exception as e:
        print(f"")                                          
else:
    print("")

count_bypassed = 0
count_critical = 0
count_high = 0
allowed_critical = 500

if vulnerabilities:
    for issue in vulnerabilities:
        severity_level = issue.get('severity', '')
        if severity_level in ('CRITICAL'):
            count_critical += 1
        elif severity_level == 'HIGH':
            count_high += 1
                        
    print("*******************************************")
    print("Roxs-security-tools")
    print("Reporte de Vulnerabilidades 🐛: ")
    print("Vulnerabilidades Críticas:", count_critical)
    print("*******************************************")

if count_critical > allowed_critical:
    if allow_failure:
        print_color("Este repositorio supera las vulnerabilidades criticas permitidas, no podrá desplegar en PRODUCCIÓN 🔥.", RED)
        exitCode = 1

sys.exit(exitCode)
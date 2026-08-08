#!/usr/bin/env python3
import sys
import os
import re
import json

def main():
    if len(sys.argv) < 3:
        print("Usage: parse_bindings.py <config_file> <commands_json>")
        sys.exit(1)
        
    config_file = sys.argv[1]
    commands_json = sys.argv[2]
    
    if not os.path.exists(config_file):
        sys.exit(0)
        
    descriptions = {}
    if os.path.exists(commands_json):
        try:
            with open(commands_json, "r") as f:
                descriptions = json.load(f)
        except Exception:
            pass

    variables = {}
    var_pattern = re.compile(r'^\$([A-Za-z0-9_]+)\s*=\s*(.*)')
    sorted_patterns = sorted(descriptions.keys(), key=len, reverse=True)
    
    with open(config_file, "r") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#"):
                continue
                
            var_match = var_pattern.match(line)
            if var_match:
                name, val = var_match.groups()
                variables[name] = val.strip()
                continue
                
            if line.startswith("bind"):
                parts = line.split("=", 1)
                if len(parts) < 2:
                    continue
                bind_args = parts[1].strip()
                
                inline_comment = ""
                if "#" in bind_args:
                    bind_args, inline_comment = bind_args.split("#", 1)
                    bind_args = bind_args.strip()
                    inline_comment = inline_comment.strip()
                    
                fields = [f.strip() for f in bind_args.split(",")]
                if len(fields) < 3:
                    continue
                    
                mod = fields[0]
                key = fields[1]
                action = fields[2]
                
                act_args = ", ".join([f for f in fields[3:] if f])
                
                mod = mod.replace("$mainMod", "SUPER")
                shortcut = f"{mod} + {key}" if mod else key
                
                full_action = action
                if act_args:
                    full_action = f"{action} {act_args}"
                    
                for var_name, var_val in variables.items():
                    full_action = full_action.replace(f"${var_name}", var_val)
                    
                friendly_desc = ""
                clean_action = full_action.replace("exec ", "").strip() if full_action.startswith("exec ") else full_action
                
                for act_candidate in [full_action, clean_action]:
                    if act_candidate in descriptions:
                        friendly_desc = descriptions[act_candidate]
                        break
                    
                    matched = False
                    for cmd_pat in sorted_patterns:
                        desc_val = descriptions[cmd_pat]
                        if act_candidate.startswith(cmd_pat):
                            remaining = act_candidate[len(cmd_pat):].strip()
                            if remaining:
                                friendly_desc = f"{desc_val} ({remaining})"
                            else:
                                friendly_desc = desc_val
                            matched = True
                            break
                        elif cmd_pat in act_candidate:
                            friendly_desc = desc_val
                            matched = True
                            break
                    if matched:
                        break
                            
                if not friendly_desc:
                    if inline_comment:
                        friendly_desc = f"{inline_comment} ({full_action})"
                    else:
                        friendly_desc = full_action
                elif inline_comment:
                    friendly_desc = f"{inline_comment} ({friendly_desc})"
                    
                row = f"{shortcut:<35} │ {friendly_desc}"
                print(row)

if __name__ == "__main__":
    main()

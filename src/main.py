import obsws_python as obs
import sys
import json

args = sys.argv
args.pop(0)
print(args)

try:
    config_file = open("config.json")
    config = json.loads(config_file.read())
except:
    print("config not found or invalid config contents\nEnsure file is correctly formatted and in the directory the script is run from")
    exit()


cl = obs.ReqClient(host=config["host"], port=config["port"], password=config["password"], timeout=config["timeout"])

if "save_replay_buffer" in args:
    print("savereplay")
    cl.save_replay_buffer()
if "toggle_replay_buffer" in args:
    print("togglereplay")
    cl.toggle_replay_buffer()
if "start_recording" in args:
    print("startrecord")
    cl.start_record()
if "stop_recording" in args:
    print("stoprecording")
    cl.stop_record()
if "toggle_virtualcam" in args:
    print("togglevirtcam")
    cl.toggle_virtual_cam()
if "stop_virtualcam" in args:
    print("stopvirtcam")
    cl.stop_virtual_cam()
if "start_virtualcam" in args:
    print("startvirtcam")
    cl.start_virtual_cam()
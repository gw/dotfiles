# Mimic tmux's prefix+z functionality by switching b/w the 'stack'
# layout and the last used non-stack layout.

def main(args):
   pass

def handle_result(args, answer, target_window_id, boss):
   tab = boss.active_tab
   if tab is not None:
      if tab.current_layout.name == 'stack':
         tab.last_used_layout()
      else:
         tab.goto_layout('stack')

handle_result.no_ui = True

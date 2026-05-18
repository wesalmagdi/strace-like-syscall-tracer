#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/syscall.h"
#include "user/user.h"
#include "kernel/fcntl.h"

static struct {
  char *name;
  int   num;
} nametable[] = {
  { "fork",   SYS_fork   },
  { "exit",   SYS_exit   },
  { "wait",   SYS_wait   },
  { "pipe",   SYS_pipe   },
  { "read",   SYS_read   },
  { "kill",   SYS_kill   },
  { "exec",   SYS_exec   },
  { "fstat",  SYS_fstat  },
  { "chdir",  SYS_chdir  },
  { "dup",    SYS_dup    },
  { "getpid", SYS_getpid },
  { "sbrk",   SYS_sbrk   },
  { "pause",  SYS_pause  },
  { "uptime", SYS_uptime },
  { "open",   SYS_open   },
  { "write",  SYS_write  },
  { "mknod",  SYS_mknod  },
  { "unlink", SYS_unlink },
  { "link",   SYS_link   },
  { "mkdir",  SYS_mkdir  },
  { "close",  SYS_close  },
};

#define NTABLE (sizeof(nametable) / sizeof(nametable[0]))

static int
parse_mask(char *filter)
{
  if(filter[0] == '\0')
    return -2;

  uint mask = 0;
  char *p = filter;

  while(*p){
    char token[32];
    int i = 0;
    while(*p && *p != ',' && i < 31)
      token[i++] = *p++;
    token[i] = '\0';
    if(*p == ',') p++;

    if(i == 0) continue;

    int found = 0;
    for(uint j = 0; j < NTABLE; j++){
      if(strcmp(token, nametable[j].name) == 0){
        mask |= (1 << nametable[j].num);
        found = 1;
        break;
      }
    }
    if(!found){
      fprintf(2, "strace: unknown syscall name '%s'\n", token);
      return -1;
    }
  }
  return (int)mask;
}

// ========== ADDED: print_usage function ==========
static void
print_usage(void)
{
  fprintf(2, "Usage: strace [-e trace=syscalls] [-o file] [-p pid] command [args...]\n");
  fprintf(2, "       strace -p pid [-o file]\n");
  exit(1);
}
// ========== END ADDED ==========

int
main(int argc, char *argv[])
{
  int mask = 0;
  int logfd = -1;
  int cmdstart = 1;
  
  // ========== ADDED: variables for attach mode ==========
  int attach_mode = 0;
  int attach_pid = 0;
  // ========== END ADDED ==========

  for(int i = 1; i < argc; i++){
    // ========== ADDED: -p option parsing ==========
    if(strcmp(argv[i], "-p") == 0){
      i++;
      if(i >= argc){
        fprintf(2, "strace: missing PID after -p\n");
        print_usage();
        exit(1);
      }
      attach_mode = 1;
      attach_pid = atoi(argv[i]);
      if(attach_pid <= 0){
        fprintf(2, "strace: invalid PID '%s'\n", argv[i]);
        exit(1);
      }
      cmdstart = i + 1;
    }
    // ========== END ADDED ==========
    else if(strcmp(argv[i], "-e") == 0){
      i++;
      if(i >= argc || memcmp(argv[i], "trace=", 6) != 0){
        fprintf(2, "strace: expected 'trace=<syscalls>' after -e\n");
        exit(1);
      }
      
      char *filter = argv[i] + 6;
      int m = parse_mask(filter);
      if(m == -1)
        exit(1);
      if(m == -2)
        mask = 1 << 31;
      else
        mask = m;
      cmdstart = i + 1;
    } else if(strcmp(argv[i], "-o") == 0){
      i++;
      if(i >= argc || argv[i][0] == '\0'){
        fprintf(2, "strace: cannot open log file\n");
        exit(1);
      }

      logfd = open(argv[i], O_WRONLY | O_CREATE | O_TRUNC);
      if(logfd < 0){
        fprintf(2, "strace: cannot open '%s'\n", argv[i]);
        exit(1);
      }

      cmdstart = i + 1;
    } else {
        cmdstart = i;
        break;
    }
  }

  // ========== ADDED: Attach mode handling ==========
  if(attach_mode){
    // In attach mode, there should be no command
    if(cmdstart < argc){
      fprintf(2, "strace: cannot use -p with a command\n");
      exit(1);
    }

    // Set trace output destination if -o was specified
    if(logfd >= 0){
      set_trace_output(logfd);
      close(logfd);
    }

    // Attach to the running process
    if(attach_trace(attach_pid, mask) < 0){
      fprintf(2, "strace: failed to attach to process %d\n", attach_pid);
      exit(1);
    }

    fprintf(2, "strace: attached to pid %d\n", attach_pid);
    
    // Wait for the traced process to finish
    int status;
    wait(&status);
    exit(0);
  }
  // ========== END ADDED ==========

  if(cmdstart >= argc){
    // ========== MODIFIED: updated usage message ==========
    fprintf(2, "usage: strace [-e trace=syscall,...] [-o file] [-p pid] command [args]\n");
    fprintf(2, "       strace -p pid [-o file]\n");
    // ========== END MODIFIED ==========
    exit(1);
  }

  // ========== MODIFIED: Keep original trace call ==========
  trace(mask, logfd);
  // ========== END MODIFIED ==========
  
  exec(argv[cmdstart], &argv[cmdstart]);
  fprintf(2, "strace: exec %s failed\n", argv[cmdstart]);
  exit(1);
}
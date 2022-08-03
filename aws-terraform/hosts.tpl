[manager]
%{ for ip in manager ~}
${ip}
%{ endfor ~}

[workers]
%{ for ip in worker1 ~}
${ip}
%{ endfor ~}
%{ for ip in worker2 ~}
${ip}
%{ endfor ~}

[workers:vars]
ansible_ssh_private_key_file=/home/jhenry/.ssh/jazz-key-pair.pem
ansible_user=ubuntu

[manager:vars]
ansible_ssh_private_key_file=/home/jhenry/.ssh/jazz-key-pair.pem
ansible_user=ubuntu
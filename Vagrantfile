# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

dir = File.dirname(File.expand_path(__FILE__))

# 从配置文件中读取配置数据
configValues = YAML.load_file("#{dir}/letian/config.yaml")
data         = configValues['vagrantfile-local']

Vagrant.require_version '>= 1.6.0'

# 下面是所有的 Vagrant 配置. 在 Vagrant.configure 中 "2" 表示配置的版本(1 是老版本)
Vagrant.configure(2) do |config|
    # 设置使用的 box..
    config.vm.box = data['vm']['box']
  
    # 配置hostname
    if data['vm']['hostname'].to_s.strip.length != 0
        config.vm.hostname = "#{data['vm']['hostname']}"
    end

    # 设置vm 的ip地址
    if data['vm']['network']['private_network'].to_s != ''
        config.vm.network 'private_network', ip: "#{data['vm']['network']['private_network']}"
    end

    # 端口转发地址
    data['vm']['network']['forwarded_port'].each do |i, port|
        if port['guest'] != '' && port['host'] != ''
            config.vm.network :forwarded_port, guest: port['guest'].to_i, host: port['host'].to_i
        end
    end
    
    # 启动信息
    if !data['vm']['post_up_message'].nil?
       config.vm.post_up_message = "#{data['vm']['post_up_message']}"
    end

    # 从环境变量中获取 provider.
    unless ENV.fetch('VAGRANT_DEFAULT_PROVIDER', '').strip.empty?
        data['vm']['chosen_provider'] = ENV['VAGRANT_DEFAULT_PROVIDER'];
    end

    # 使用virtualbox 进行相应配置
    if data['vm']['chosen_provider'].empty? || data['vm']['chosen_provider'] == 'virtualbox'
        ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'
      
        config.vm.provider :virtualbox do |virtualbox|
          
            # 配置内存和cpu占用
            virtualbox.customize ['modifyvm', :id, '--memory', "#{data['vm']['memory']}"]
            virtualbox.customize ['modifyvm', :id, '--cpus', "#{data['vm']['cpus']}"]
            # 修改vm 的标识
        end
    end

    # ssh 的用户名
    ssh_username = !data['ssh']['username'].nil? ? data['ssh']['username'] : 'vagrant'

    ## 执行一些shell provision 进行设置
    # 初始化设置
    config.vm.provision 'shell' do |s|
        s.path = 'letian/shell/initial-setup.sh'
        s.args = '/vagrant/letian'
    end
    
    # 生成ssh 的key
    config.vm.provision 'shell' do |kg|
        kg.path = 'letian/shell/ssh-keygen.sh'
        kg.args = "#{ssh_username}"
    end

    # 安装ruby
    config.vm.provision :shell, :path => 'letian/shell/install-ruby.sh'
    # 安装 puppet
    config.vm.provision :shell, :path => 'letian/shell/install-puppet.sh'

    # 对 puppet provision 进行设置,（还没写完，puppet 正在学习中。。。)
    # config.vm.provision :puppet do |puppet|
    #    puppet.facter = {
    #      'ssh_username'     => "#{ssh_username}",
    #      'provisioner_type' => ENV['VAGRANT_DEFAULT_PROVIDER'],
    #      'vm_target_key'    => 'vagrantfile-local',
    #    }
    #    puppet.manifests_path = "#{data['vm']['provision']['puppet']['manifests_path']}"
    #    puppet.manifest_file  = "#{data['vm']['provision']['puppet']['manifest_file']}"
    #    puppet.module_path    = "#{data['vm']['provision']['puppet']['module_path']}"
      
        # 如果有其他选项，设置一下
    #    if !data['vm']['provision']['puppet']['options'].empty?
    #        puppet.options = data['vm']['provision']['puppet']['options']
    #    end
    #end
  
    # 只会执行一次 , 有点小bug , 先注释掉
    #config.vm.provision :shell do |s|
    #    s.path = 'letian/shell/execute-files.sh'
    #    s.args = ['exec-once', 'exec-always']
    #end
    # 每次 vagrant up 时候会执行
    #config.vm.provision :shell, run: 'always' do |s|
    #    s.path = 'letian/shell/execute-files.sh'
    #    s.args = ['startup-once', 'startup-always']
    #end
    
    # 重要提示
    config.vm.provision :shell, :path => 'letian/shell/important-notices.sh'
    
    ## 复制key 到${VAGRANT_HOME} 目录
    # 找到 VAGRANT_HOME 位置
    customKey  = "#{dir}/files/dot/ssh/id_rsa"
    vagrantKey = "#{dir}/.vagrant/machines/default/#{ENV['VAGRANT_DEFAULT_PROVIDER']}/private_key"
    if !ENV['VAGRANT_HOME'].nil? 
        vagrantHome = ENV['VAGRANT_HOME']
    else
        vagrantHome = ENV['HOME']
    end
    if File.file?(customKey)
        config.ssh.private_key_path = [
            customKey,
            "#{vagrantHome}/.vagrant.d/insecure_private_key"
        ]

        if File.file?(vagrantKey) and ! FileUtils.compare_file(customKey, vagrantKey)
            File.delete(vagrantKey)
        end

        if ! File.directory?(File.dirname(vagrantKey))
            FileUtils.mkdir_p(File.dirname(vagrantKey))
        end

        if ! File.file?(vagrantKey)
            FileUtils.cp(customKey, vagrantKey)
        end
    end    
    # vagrant 的ssh 配置
    if !data['ssh']['host'].nil?
        config.ssh.host = "#{data['ssh']['host']}"
    end
    if !data['ssh']['port'].nil?
        config.ssh.port = "#{data['ssh']['port']}"
    end
    if !data['ssh']['username'].nil?
        config.ssh.username = "#{data['ssh']['username']}"
    end
    if !data['ssh']['guest_port'].nil?
        config.ssh.guest_port = data['ssh']['guest_port']
    end
    if !data['ssh']['shell'].nil?
        config.ssh.shell = "#{data['ssh']['shell']}"
    end
    if !data['ssh']['keep_alive'].nil?
        config.ssh.keep_alive = data['ssh']['keep_alive']
    end
    if !data['ssh']['forward_agent'].nil?
        config.ssh.forward_agent = data['ssh']['forward_agent']
    end
    if !data['ssh']['forward_x11'].nil?
        config.ssh.forward_x11 = data['ssh']['forward_x11']
    end
    if !data['vagrant']['host'].nil?
        config.vagrant.host = data['vagrant']['host'].gsub(':', '').intern
    end
    
    # 关闭box 更新检查。 关闭后， 只有在 `vagrant box outdated` 的时候才会检查更新
    config.vm.box_check_update = false

end

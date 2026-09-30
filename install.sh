#!/bin/bash

###############################################################################
# Linux Python 开发环境一键安装脚本
# 支持: Ubuntu, Debian, CentOS, Fedora
# 功能: 安装 Python、pip、虚拟环境、Git 和常用开发工具
###############################################################################

set -e  # 任何命令失败都退出

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查是否为 root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "此脚本需要 root 权限，请使用 sudo 运行"
        exit 1
    fi
}

# 检测 Linux 发行版
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
        VERSION=$VERSION_ID
    else
        log_error "无法检测操作系统"
        exit 1
    fi
    
    log_info "检测到操作系统: $OS $VERSION"
}

# Ubuntu/Debian 安装
install_ubuntu() {
    log_info "开始 Ubuntu/Debian 系统安装..."
    
    # 更新包管理器
    log_info "更新系统包..."
    apt-get update
    apt-get upgrade -y
    
    # 安装基础依赖
    log_info "安装基础依赖..."
    apt-get install -y \
        build-essential \
        libssl-dev \
        libffi-dev \
        python3-dev \
        python3-venv \
        python3-pip \
        git \
        wget \
        curl \
        vim \
        nano \
        htop \
        tmux \
        zsh
    
    # 安装 Python 3.11 (可选)
    log_info "安装 Python 3.11..."
    apt-get install -y software-properties-common
    add-apt-repository ppa:deadsnakes/ppa -y
    apt-get update
    apt-get install -y python3.11 python3.11-venv python3.11-dev
    
    log_success "Ubuntu/Debian 安装完成"
}

# CentOS/RHEL 安装
install_centos() {
    log_info "开始 CentOS/RHEL 系统安装..."
    
    # 更新包管理器
    log_info "更新系统包..."
    yum update -y
    
    # 安装基础依赖
    log_info "安装基础依赖..."
    yum groupinstall -y "Development Tools"
    yum install -y \
        python3-devel \
        python3-pip \
        openssl-devel \
        git \
        wget \
        curl \
        vim \
        nano \
        htop \
        tmux \
        zsh
    
    # 安装 Python 3.11 (可选)
    log_info "安装 Python 3.11..."
    yum install -y python3.11 python3.11-devel
    
    log_success "CentOS/RHEL 安装完成"
}

# Fedora 安装
install_fedora() {
    log_info "开始 Fedora 系统安装..."
    
    # 更新包管理器
    log_info "更新系统包..."
    dnf update -y
    
    # 安装基础依赖
    log_info "安装基础依赖..."
    dnf groupinstall -y "Development Tools"
    dnf install -y \
        python3-devel \
        python3-pip \
        openssl-devel \
        git \
        wget \
        curl \
        vim \
        nano \
        htop \
        tmux \
        zsh
    
    log_success "Fedora 安装完成"
}

# 升级 pip
upgrade_pip() {
    log_info "升级 pip..."
    python3 -m pip install --upgrade pip setuptools wheel
    log_success "pip 升级完成"
}

# 安装常用 Python 包
install_python_packages() {
    log_info "安装常用 Python 包..."
    
    python3 -m pip install -q \
        ipython \
        jupyter \
        numpy \
        pandas \
        requests \
        flask \
        django \
        pytest \
        black \
        flake8 \
        pylint \
        mypy \
        poetry \
        pipenv
    
    log_success "Python 包安装完成"
}

# 配置 Git
configure_git() {
    log_info "配置 Git..."
    
    # 检查是否已配置
    if git config --global user.name > /dev/null 2>&1; then
        log_warning "Git 已配置，跳过配置步骤"
        return
    fi
    
    read -p "请输入 Git 用户名: " git_name
    read -p "请输入 Git 邮箱: " git_email
    
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    git config --global core.editor vim
    
    log_success "Git 配置完成"
}

# 创建项目模板
create_project_template() {
    log_info "创建项目模板..."
    
    mkdir -p ~/python-projects/demo-project
    cd ~/python-projects/demo-project
    
    # 创建虚拟环境
    python3 -m venv venv
    
    # 创建项目结构
    mkdir -p src tests
    
    # 创建 .gitignore
    cat > .gitignore << 'EOF'
# 虚拟环境
venv/
env/
.env

# Python 缓存
__pycache__/
*.py[cod]
*$py.class
*.so

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# 包
dist/
build/
*.egg-info/

# 测试
.pytest_cache/
.coverage
htmlcov/
EOF
    
    # 创建 requirements.txt
    cat > requirements.txt << 'EOF'
# 项目依赖示例
requests>=2.28.0
flask>=2.0.0
pytest>=7.0.0
EOF
    
    # 创建示例 Python 文件
    cat > src/main.py << 'EOF'
"""
Python 开发环境演示脚本
"""

def hello_world():
    """打印欢迎信息"""
    print("欢迎使用 Linux Python 开发环境！")
    print(f"Python 版本: {__import__('sys').version}")

if __name__ == "__main__":
    hello_world()
EOF
    
    # 创建 README
    cat > README.md << 'EOF'
# Python 项目模板

## 项目设置

```bash
# 激活虚拟环境
source venv/bin/activate

# 安装依赖
pip install -r requirements.txt

# 运行项目
python src/main.py

# 运行测试
pytest tests/
```

## 项目结构

```
.
├── src/              # 源代码
├── tests/            # 测试代码
├── venv/             # 虚拟环境
├── requirements.txt  # 项目依赖
└── README.md        # 项目说明
```
EOF
    
    log_success "项目模板创建在: ~/python-projects/demo-project"
}

# 打印安装总结
print_summary() {
    echo ""
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║     Python 开发环境安装完成！                          ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo ""
    echo -e "${GREEN}已安装的主要组件:${NC}"
    echo "  ✓ Python 3 (默认)"
    echo "  ✓ Python 3.11"
    echo "  ✓ pip / setuptools / wheel"
    echo "  ✓ Git"
    echo "  ✓ 常用开发工具 (vim, curl, wget, htop 等)"
    echo "  ✓ 常用 Python 包 (numpy, pandas, flask, django 等)"
    echo ""
    echo -e "${GREEN}快速开始:${NC}"
    echo "  1. 检查 Python 版本: python3 --version"
    echo "  2. 创建虚拟环境: python3 -m venv myenv"
    echo "  3. 激活虚拟环境: source myenv/bin/activate"
    echo "  4. 安装包: pip install <package-name>"
    echo ""
    echo -e "${GREEN}示例项目位置:${NC}"
    echo "  ~/python-projects/demo-project"
    echo ""
    echo -e "${GREEN}有用的命令:${NC}"
    echo "  pip list              # 列出已安装的包"
    echo "  pip freeze > req.txt  # 导出依赖列表"
    echo "  python3 -m venv env   # 创建虚拟环境"
    echo "  deactivate            # 退出虚拟环境"
    echo ""
}

# 主函数
main() {
    log_info "开始 Linux Python 开发环境安装..."
    echo ""
    
    check_root
    detect_os
    
    case "$OS" in
        ubuntu|debian)
            install_ubuntu
            ;;
        centos|rhel)
            install_centos
            ;;
        fedora)
            install_fedora
            ;;
        *)
            log_error "不支持的操作系统: $OS"
            exit 1
            ;;
    esac
    
    upgrade_pip
    install_python_packages
    configure_git
    create_project_template
    
    print_summary
    
    log_success "安装脚本执行完成！"
}

# 执行主函数
main

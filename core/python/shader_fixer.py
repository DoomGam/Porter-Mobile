import os
import re
import sys

def fix_shader_content(content):
    """
    Adapta o código do Shader GLSL para OpenGL ES (Mobile).
    """
    if "precision" not in content and "#version" not in content:
        content = "#ifdef GL_ES\nprecision mediump float;\n#endif\n\n" + content
    elif "precision" not in content and "#version" in content:
        lines = content.split('\n')
        new_lines = []
        precision_added = False
        for line in lines:
            new_lines.append(line)
            if line.startswith("#version") and not precision_added:
                new_lines.append("\n#ifdef GL_ES\nprecision mediump float;\n#endif\n")
                precision_added = True
        content = "\n".join(new_lines)

    content = re.sub(r'\btexture2D\b', 'texture', content)

    return content

def process_shaders_in_directory(directory_path):
    """
    Escaneia a pasta informada e aplica as correções em todos os arquivos .frag e .vert.
    """
    fixed_count = 0
    if not os.path.exists(directory_path):
        print(f"[Porter-Error] Diretorio de shaders nao encontrado: {directory_path}")
        return fixed_count

    for root, _, files in os.walk(directory_path):
        for file in files:
            if file.endswith(('.frag', '.vert', '.glsl')):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                        original_code = f.read()

                    fixed_code = fix_shader_content(original_code)

                    if original_code != fixed_code:
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.write(fixed_code)
                        print(f"[ShaderFixer] Corrigido: {file_path}")
                        fixed_count += 1
                except Exception as e:
                    print(f"[ShaderFixer-Error] Falha ao processar {file_path}: {e}")

    return fixed_count

if __name__ == "__main__":
    target_dir = sys.argv[1] if len(sys.argv) > 1 else "."
    print(f"[ShaderFixer] Iniciando varredura de Shaders em: {target_dir}")
    total_fixed = process_shaders_in_directory(target_dir)
    print(f"[ShaderFixer] Concluido. Total de shaders corrigidos: {total_fixed}")

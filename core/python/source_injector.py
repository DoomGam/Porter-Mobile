import os
import sys

def inject_mobile_support(project_xml_path):
    """
    Verifica e injeta dependencias nativas mobile no Project.xml com seguranca.
    """
    if not os.path.exists(project_xml_path):
        print(f"[SourceInjector-Error] Project.xml nao encontrado em: {project_xml_path}")
        return False

    try:
        with open(project_xml_path, 'r', encoding='utf-8') as f:
            content = f.read()

        if '<haxelib name="extension-androidtools"' not in content:
            replacement = '	<haxelib name="extension-androidtools" if="android" />\n</project>'
            content = content.replace('</project>', replacement)

            with open(project_xml_path, 'w', encoding='utf-8') as f:
                f.write(content)
            print("[SourceInjector] Injetada a biblioteca extension-androidtools no Project.xml!")
        else:
            print("[SourceInjector] extension-androidtools ja esta presente no Project.xml.")

        return True

    except Exception as e:
        print(f"[SourceInjector-Error] Erro ao injetar configuracoes: {e}")
        return False

if __name__ == "__main__":
    path = sys.argv[1] if len(sys.argv) > 1 else "Project.xml"
    inject_mobile_support(path)

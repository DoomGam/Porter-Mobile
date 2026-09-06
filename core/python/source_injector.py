import os
import sys
import xml.etree.ElementTree as ET

def inject_mobile_support(project_xml_path):
    """
    Injeta bibliotecas e tags de compilação mobile no Project.xml do mod.
    """
    if not os.path.exists(project_xml_path):
        print(f"[SourceInjector-Error] Project.xml nao encontrado em: {project_xml_path}")
        return False

    try:
        tree = ET.parse(project_xml_path)
        root = tree.getroot()

        has_android_tools = False
        for haxelib in root.findall('haxelib'):
            if haxelib.get('name') == 'extension-androidtools':
                has_android_tools = True
                break

        if not has_android_tools:
            android_lib = ET.Element('haxelib', {'name': 'extension-androidtools', 'if': 'android'})
            root.append(android_lib)
            print("[SourceInjector] Injetada haxelib 'extension-androidtools'")

        tree.write(project_xml_path, encoding='utf-8', xml_declaration=True)
        print("[SourceInjector] Project.xml atualizado com sucesso!")
        return True

    except Exception as e:
        print(f"[SourceInjector-Error] Erro ao injetar configuracoes no Project.xml: {e}")
        return False

if __name__ == "__main__":
    path = sys.argv[1] if len(sys.argv) > 1 else "Project.xml"
    inject_mobile_support(path)

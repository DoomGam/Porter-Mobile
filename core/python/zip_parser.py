import os
import sys
import json
import zipfile
import xml.etree.ElementTree as ET

def parse_mod_zip(zip_path):
    """
    Lê o arquivo .zip da source do mod, analisa a estrutura de pastas,
    identifica a Engine utilizada e extrai metadados essenciais.
    """
    result = {
        "success": False,
        "title": "Unknown Mod",
        "engine": "Custom Engine",
        "has_project_xml": False,
        "icon_path": None,
        "error": None
    }

    if not os.path.exists(zip_path):
        result["error"] = f"Arquivo nao encontrado: {zip_path}"
        return result

    try:
        with zipfile.ZipFile(zip_path, 'r') as archive:
            file_list = archive.namelist()

            project_xml_files = [f for f in file_list if f.endswith('Project.xml')]
            if project_xml_files:
                result["has_project_xml"] = True
                try:
                    xml_data = archive.read(project_xml_files[0])
                    root = ET.fromstring(xml_data)
                    meta = root.find('meta')
                    if meta is not None and 'title' in meta.attrib:
                        result["title"] = meta.attrib['title']
                except Exception as xml_err:
                    print(f"[Porter-Warning] Erro ao analisar Project.xml: {xml_err}")

            file_list_str = " ".join(file_list).lower()
            if "codename" in file_list_str or "cdnm" in file_list_str:
                result["engine"] = "Codename Engine"
            elif "psych" in file_list_str or "psychEngine" in file_list_str:
                result["engine"] = "Psych Engine"
            elif "nightmare" in file_list_str:
                result["engine"] = "Nightmare Vision"

            icon_candidates = [f for f in file_list if f.lower().endswith(('icon.png', 'iconog.png', 'art/icon.png'))]
            if icon_candidates:
                result["icon_path"] = icon_candidates[0]

            result["success"] = True

    except Exception as e:
        result["error"] = str(e)

    return result

if __name__ == "__main__":
    if len(sys.argv) > 1:
        zip_input = sys.argv[1]
        mod_info = parse_mod_zip(zip_input)
        print(json.dumps(mod_info, indent=2))
    else:
        print("Uso: python zip_parser.py <caminho_do_zip>")

# /usr/local/bin/python3
# -*- coding: utf-8 -*-

import os
import sys
import glob
import shutil
import pprint

from PIL import Image

iPhone = True
iPad = False

if sys.version_info < (3, 4):
    import biplist
    def read_plist(path):
        return biplist.readPlist(path)

    def write_plist(info, path):
        biplist.writePlist(info, path, binary=False)

else:
    import plistlib
    def read_plist(path):
        with open(path, 'rb') as f:
            return plistlib.load(f)

    def write_plist(info, path):
        with open(path, 'wb') as fp:
            plistlib.dump(info, fp)

src_root = os.path.dirname(os.path.realpath(__file__))
input_dir = os.path.join(src_root, "logos")
output_dir = os.path.join(src_root, "icons")

iPhone_size_scall = [
    (20, 2),
    (20, 3),
    (29, 2),
    (29, 3),
    (40, 2),
    (40, 3),
    (60, 2),
    (60, 3),
]

iPad_size_scall = [
    (20, 1),
    (20, 2),
    (29, 1),
    (29, 2),
    (40, 1),
    (40, 2),
    (76, 1),
    (76, 2),
    (83.5, 2),
]


def convertImage(imageFile, outdir, size, scale, is_iPhone):
    image = Image.open(imageFile)
    try:
        basename = os.path.basename(imageFile)
        name = os.path.splitext(basename)[0]
        scale_string = "" if scale == 1 else "@%dx" % scale
        suffix = "" if is_iPhone else "~ipad"
        new_name = "{name}{size}x{size}{scale_string}{suffix}.png".format(
            name=name,
            size=size,
            scale_string=scale_string,
            suffix=suffix,
        )
        size_of_scale = int(size*scale)
        resize = (size_of_scale, size_of_scale)
        new_image = image.resize(resize, Image.BILINEAR)
        new_image.save(os.path.join(output_dir, new_name))
    except Exception as e:
        print(e)


def createCFBundleIconFiles(name, is_iPhone):
    CFBundleIconFiles = set()
    size_scale_array = iPhone_size_scall if is_iPhone else iPad_size_scall
    for (size, scale) in size_scale_array:
        file_name = "{name}{size}x{size}".format(
            name=name,
            size=size,
        )
        CFBundleIconFiles.add(file_name)
    CFBundleIconFilesArray = list(CFBundleIconFiles)
    CFBundleIconFilesArray.sort()
    return CFBundleIconFilesArray


def createCFBundleAlternateIconSingle(name, is_iPhone):
    CFBundleIconFiles = createCFBundleIconFiles(name, is_iPhone)
    info_dict = {"UIPrerenderedIcon": False}
    info_dict["CFBundleIconFiles"] = CFBundleIconFiles
    return info_dict


def createPrimaryIconInfo(primaryIconName, is_iPhone):
    CFBundlePrimaryIcon = {}
    CFBundlePrimaryIcon["CFBundleIconName"] = primaryIconName
    CFBundleIconFiles = createCFBundleIconFiles(primaryIconName, is_iPhone)
    CFBundlePrimaryIcon["CFBundleIconFiles"] = CFBundleIconFiles
    return CFBundlePrimaryIcon


def createCFBundleAlternateIcons(names, is_iPhone):
    CFBundleAlternateIcons = {
        "UINewsstandBindingType": "UINewsstandBindingTypeMagazine",
        "UINewsstandBindingEdge": "UINewsstandBindingEdgeLeft",
    }
    for name in names:
        CFBundleAlternateIcons[name] = createCFBundleAlternateIconSingle(name, is_iPhone)
    return CFBundleAlternateIcons


def createNewIconInfo(names, newPrimaryIcon, oldPrimaryInfo, is_iPhone):
    key = "CFBundleIcons" if is_iPhone else "CFBundleIcons~ipad"
    icons = {}
    icons["CFBundleAlternateIcons"] = createCFBundleAlternateIcons(names, is_iPhone)
    if newPrimaryIcon == None or newPrimaryIcon == "":
        if oldPrimaryInfo != None:
            icons["CFBundlePrimaryIcon"] = oldPrimaryInfo
    else:
        icons["CFBundlePrimaryIcon"] = createPrimaryIconInfo(newPrimaryIcon, is_iPhone)

    return icons


def moveIconsToDirectory(origin_dir_path, dest_dir_path):
    imageRe = os.path.join(origin_dir_path, "*.png")
    for imageFile in glob.glob(imageRe):
        basename = os.path.basename(imageFile)
        dest_file_path = os.path.join(dest_dir_path, basename)
        shutil.move(imageFile, dest_file_path)


def setIcon(plist_info, newIconNames, newPrimaryIcon, is_iPhone):
    key = "CFBundleIcons" if is_iPhone else "CFBundleIcons~ipad"
    primaryIconKey = "CFBundlePrimaryIcon"

    if not plist_info.__contains__(key) or not plist_info[key].__contains__(primaryIconKey):
        return
    
    oldPrimaryInfo = plist_info[key][primaryIconKey]
    newIconInfo = createNewIconInfo(newIconNames, newPrimaryIcon, oldPrimaryInfo, is_iPhone)
    plist_info[key] = newIconInfo



if __name__ == '__main__':
    """Create Dir"""
    if os.path.exists(output_dir):
        if os.path.isfile(output_dir):
            os.remove(output_dir)
        elif os.path.isdir(output_dir):
            shutil.rmtree(output_dir, ignore_errors=True)
    os.makedirs(output_dir, exist_ok=False)

    """Convert icons"""
    imageRe = os.path.join(input_dir, "*.png")
    iconNames = []
    for imageFile in glob.glob(imageRe):
        basename = os.path.basename(imageFile)
        name = os.path.splitext(basename)[0]
        iconNames.append(name)
        for (size, scale) in iPhone_size_scall:
            convertImage(imageFile, output_dir, size, scale, iPhone)
        for (size, scale) in iPad_size_scall:
            convertImage(imageFile, output_dir, size, scale, iPad)


    """Add icons to App"""
    app_content_path = os.getenv("APP_CONTENT_PATH")

    if app_content_path == None:
        raise ValueError("No `APP_CONTENT_PATH` Environment Variable")
    if not os.path.exists(app_content_path):
        raise ValueError("%s not Exists" % app_content_path)

    print("Move App icons: `%s` => `%s`" % (output_dir, app_content_path))
    moveIconsToDirectory(output_dir, app_content_path)
    print("Add App Icon Success")

    """Edit Info.plist"""
    primaryIconName = os.getenv("PRIMARY_ICON_NAME")
    plistFilePath = os.path.join(app_content_path, "Info.plist")

    if not os.path.exists(plistFilePath):
        raise ValueError("%s not Exists" % plistFilePath)

    print("Edit Info.plist: ", plistFilePath)
    plistInfo = read_plist(plistFilePath)


    """set icons"""
    setIcon(plistInfo, iconNames, primaryIconName, iPhone)
    setIcon(plistInfo, iconNames, primaryIconName, iPad)

    os.remove(plistFilePath)
    write_plist(plistInfo, plistFilePath)

    pp = pprint.PrettyPrinter(indent=4)
    pp.pprint(plistInfo)

    print("Edit Info.plist Success")

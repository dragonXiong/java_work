package com.whty.web.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.Map;
import java.util.Random;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.google.common.collect.Maps;
import com.whty.common.util.PropertiesUtil;
import com.whty.common.util.Uuid;

import jodd.io.FileUtil;
import jodd.util.StringUtil;
import jodd.util.SystemUtil;

@Controller
@RequestMapping(value="file")
public class FileController{
	
	protected Logger log = LoggerFactory.getLogger(getClass());
	
	@RequestMapping(value="uploadFile")
	public String uploadFile(Integer type,Integer maxNum,Model model){
		model.addAttribute("type", type==null?new Random().nextInt(100):type);//type:弹窗序号，用于单页面加载多个上传
		model.addAttribute("maxNum", maxNum==null?5:maxNum);//最大上传个数
		return "inc/uploadFile";
	}
	
	//保存文件
	@RequestMapping(value="saveFile")
	@ResponseBody
	public Map<String,Object> saveFile(MultipartFile file,Integer isImage)
			throws ServletException, IOException{
		Map<String,Object> res = Maps.newHashMap();
		File destFile = null;
		try {
			if(null!=file&&!file.isEmpty()){
				String orgName = file.getOriginalFilename();
				String fileExt = orgName.substring(orgName.lastIndexOf(".") + 1).toLowerCase();//文件类型
				String extNames = PropertiesUtil.getValueString("upload.ext");//允许上传的文件名
				if (!Arrays.<String> asList(extNames.split(",")).contains(fileExt)) {// 检查扩展名
					String error = "上传文件扩展名是不允许的扩展名。\n只允许" + extNames + "格式。";
					res.put("code",2);//文件扩展名不对
					res.put("msg",error);
					return res;
				} 
				String savePath = getSavePath(isImage);
				File uploadDir = new File(savePath);
				if(!uploadDir.canWrite()){
					res.put("code",2);
					res.put("msg","上传目录没有写权限");
					return res;
				}
				String newFileName = Uuid.getUUID()+"."+fileExt;//新的文件名
				destFile = getFileByName(newFileName,isImage);
				file.transferTo(destFile);
				res.put("code", 1);
				res.put("orgName", orgName);
				res.put("newName",newFileName);
			}else{
				res.put("code", 0);
				res.put("msg", "上传文件不存在");
			}
		} catch (Exception e) {
			res.put("retCode", 3);
			res.put("msg", "上传文件失败。");
			log.info("上传文件失败",e);
		}
		return res;
	}
	
	//删除文件
	@RequestMapping(value = "deleteFile")
	@ResponseBody
	public Map<String,Object> delete(String newFileName,Integer isImage) {
		Map<String,Object> result = Maps.newHashMap();
		try {
			if (StringUtil.isNotBlank(newFileName)) {
				File destFile = getFileByName(newFileName,isImage);
				if(null!=destFile&&destFile.exists()){
					FileUtil.delete(destFile);
				}
			}
			result.put("code", 1);
		} catch (Exception e) {
			log.error("删除文件失败", e);
			result.put("code", 0);
			result.put("msg", "删除文件失败");
		}
		return result;
	}
	
	//文件下载或图片查看
	//示例：<img src="${path }/file/download?fileName=${ru.logo}&isImage=1"/>参数要带上isImage=1 
	@RequestMapping("/download")  
	public ModelAndView download(HttpServletResponse response,String fileName,Integer isImage) throws Exception {
		java.io.BufferedInputStream bis = null;
		java.io.BufferedOutputStream bos = null;
		String downLoadPath = getSavePath(isImage)+fileName;
		//TODO 这里要通过新的文件名查数据库获得原来的文件名
		String oldFileName = "download";
		try {
			long fileLength = new File(downLoadPath).length();
			String newfileExt = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();//文件类型
			String oldfileExt = oldFileName.substring(oldFileName.lastIndexOf(".") + 1).toLowerCase();//重命名后是否还带有扩展名的后缀
			if(!newfileExt.equalsIgnoreCase(oldfileExt)){
				oldFileName=oldFileName+"."+newfileExt;//如果重命名后不带后缀，自动补上
			}
			if(isImage==1){
				response.setContentType("image/png");
			}else{
				String header="attachment; filename="+oldFileName;
				response.setContentType("application/x-msdownload;");
				response.setHeader("Content-disposition",header);
			}
			response.setHeader("Content-Length", String.valueOf(fileLength));
			bis = new BufferedInputStream(new FileInputStream(downLoadPath));
			bos = new BufferedOutputStream(response.getOutputStream());
			byte[] buff = new byte[2048];
			int bytesRead;
			while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
				bos.write(buff, 0, bytesRead);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (bis != null)
				bis.close();
			if (bos != null)
				bos.close();
		}
		return null;
	}
	
	
	//新的文件对象
	private File getFileByName(String name,Integer isImage) {
		String savePath = getSavePath(isImage);
		savePath += File.separator + name;
		return new File(savePath);
	}
	//文件保存路径
	private String getSavePath(Integer isImage) {
		String dirName = "";
		if(null!=isImage&&isImage==1){//上传的是图片
			dirName="images";
		}else{
			dirName="files";
		}
		String savePath = "";
		if (SystemUtil.isHostWindows()) {
			savePath = PropertiesUtil.getValueString("upload.windows");
		} else if (SystemUtil.isHostLinux()) {
			savePath = PropertiesUtil.getValueString("upload.linux");
		}
		// 创建文件夹
		savePath += File.separator+dirName+ File.separator;
		File saveDirFile = new File(savePath);
		if (!saveDirFile.exists()) {
			saveDirFile.mkdirs();
		}
		return savePath+File.separator;
	}
}

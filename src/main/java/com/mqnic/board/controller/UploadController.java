package com.mqnic.board.controller;

import com.mqnic.board.domain.AttachFileDTO;
import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;
import org.apache.tika.Tika;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@Log4j
public class UploadController {


	@GetMapping("uploadAjax")
	public void uploadAjax() {
		log.info("upload Ajax");
	}

	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/uploadAjaxAction",produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxAction(MultipartFile[] uploadFile) {
		log.info("upload ajax post.....");

		List<AttachFileDTO> list = new ArrayList<>();
		String uploadFolder = "/Users/sanggi-son/upload";

		//make folder
		File uploadPath = new File(uploadFolder,getFolder());
		log.info("upload path : " + uploadPath);

		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		for (MultipartFile mf : uploadFile) {

			AttachFileDTO attachFileDTO = new AttachFileDTO();

			log.info("-----------------------");
			log.info("Upload File Name : " + mf.getOriginalFilename());
			log.info("Upload File Size : " + mf.getSize());

			String uploadFileName = mf.getOriginalFilename();
			String uploadFolderPath = getFolder();

			attachFileDTO.setFileName(uploadFileName);

			// IE has file path
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);

			log.info("only file name : " + uploadFileName);

			UUID uuid = UUID.randomUUID();

			uploadFileName = uuid.toString() + "_" + uploadFileName;


			try {
				File saveFile = new File(uploadPath, uploadFileName);
				mf.transferTo(saveFile);

				attachFileDTO.setUuid(uuid.toString());
				attachFileDTO.setUploadPath(uploadFolderPath);

				log.info("check image file : "+checkImageType(saveFile));

				if(checkImageType(saveFile)) {
					attachFileDTO.setImage(true);

					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath,"s_"+uploadFileName));

					Thumbnailator.createThumbnail(mf.getInputStream(),thumbnail,100,100);

					thumbnail.close();
				}
				// add to list
				list.add(attachFileDTO);

			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return new ResponseEntity<>(list, HttpStatus.OK);
	}

	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName) {

		log.info("fileName : " + fileName);

		File file = new File("/Users/sanggi-son/upload/"+fileName);

		log.info(file);

		ResponseEntity<byte[]> result = null;

		try {
			HttpHeaders header = new HttpHeaders();

			header.add("Content-Type", new Tika().detect(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file),header,HttpStatus.OK);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}

	@GetMapping(value = "/download",produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> download(@RequestHeader("User-Agent") String userAgent, String fileName) {

		log.info("download file : " + fileName);

		Resource resource = new FileSystemResource("/Users/sanggi-son/upload/"+fileName);

		log.info("resource name : " + resource);

		if(resource.exists() == false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}

		String resourceName = resource.getFilename();

		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_")+1);

		HttpHeaders headers = new HttpHeaders();

		try {

			String downloadName = null;

			if(userAgent.contains("Trident")) {
				log.info("IE browser");

				downloadName = URLEncoder.encode(resourceOriginalName,"UTF-8").replaceAll("/+"," ");
			} else if(userAgent.contains("Edge")) {
				log.info("IE browser");

				downloadName = URLEncoder.encode(resourceOriginalName,"UTF-8");
			} else {
				log.info("chrome browser");

				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
			}
			headers.add("Content-Disposition","attachment; filename="+downloadName);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}

	@PreAuthorize("isAuthenticated()")
	@ResponseBody
	@PostMapping("/deleteFile")
	public ResponseEntity<String> deleteFile(String fileName, String type) {

		log.info("deleteFile : " + fileName);

		File file;

		try {

			file = new File("/Users/sanggi-son/upload/",URLDecoder.decode(fileName,"UTF-8"));

			file.delete();

			if(type.equals("image")) {
				String largeFileName = file.getAbsolutePath().replace("s_","");

				log.info("largeFileName : " + largeFileName);

				file = new File(largeFileName);
				file.delete();
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}

		return new ResponseEntity<String>("deleted",HttpStatus.OK);
	}

	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		Date date = new Date();

		String str = sdf.format(date);
		log.info("getFolder : "+str.replace("-",File.separator));
		return str.replace("-",File.separator);
	}

	private boolean checkImageType(File file) {

		try {
			String contentType = new Tika().detect(file);
			log.info("contentTyple : " + contentType);

			return contentType.startsWith("image");
		} catch (IOException e) {
			e.printStackTrace();
		}
		return false;
	}
}

package com.tiim.fileutil;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.tiim.model.ProductReport;



public class CreateExcelReport {
	 
	private CellStyle cs = null;
	 private CellStyle csBold = null;
	 private CellStyle csTop = null;
	 private CellStyle csRight = null;
	 private CellStyle csBottom = null;
	 private CellStyle csLeft = null;
	 private CellStyle csTopLeft = null;
	 private CellStyle csTopRight = null;
	 private CellStyle csBottomLeft = null;
	 private CellStyle csBottomRight = null;
	 
	public void writeProductExcel(List<ProductReport> lstProduct, String excelFilePath, String flag)
	{
		try{
				Workbook workbook = getWorkbook(excelFilePath);
				setCellStyles(workbook);
				
				Sheet sheet = workbook.createSheet();
				 sheet.setColumnWidth(0, 2500); 
				   sheet.setColumnWidth(1, 8000);
				   sheet.setColumnWidth(2, 8000);
				   sheet.setColumnWidth(3, 8000);
				   sheet.setColumnWidth(4, 8000);
				   sheet.setColumnWidth(5, 8000); 
				   sheet.setColumnWidth(6, 8000);
				   sheet.setColumnWidth(7, 8000);
				   sheet.setColumnWidth(8, 8000);
				   sheet.setColumnWidth(9, 8000);
				   if("Interval".equalsIgnoreCase(flag))
				   {
					   sheet.setColumnWidth(10, 8000);
				   }
				int rowCount = 0;
				Row headerRow = sheet.createRow(++rowCount);
				createHeader(headerRow, flag);
				for (ProductReport product : lstProduct) {
					Row row = sheet.createRow(++rowCount);
					writeProductReportBook(product, row, flag);
				}
				
				FileOutputStream outputStream = new FileOutputStream(excelFilePath);
				workbook.write(outputStream);
		}catch(Exception exception)
		{
			System.out.println("Exception when writing the product report: "+exception.getMessage());
		}
	}
	
	private void createHeader(Row row, String flag)
	{

		Cell cell = row.createCell(1);
		cell.setCellValue("ProductName");
		cell.setCellStyle(csBold);
		
		cell = row.createCell(2);
		cell.setCellValue("Machine Type");
		cell.setCellStyle(csBold);
		
		cell = row.createCell(3);
		cell.setCellValue("Type of Tool");
		cell.setCellStyle(csBold);
		
		cell = row.createCell(4);
		cell.setCellValue("Lot Number");
		cell.setCellStyle(csBold);
		
		cell = row.createCell(5);
		cell.setCellValue("Tooling Life");
		cell.setCellStyle(csBold);
		
		cell = row.createCell(6);
		cell.setCellValue("Service Interval Quantity");
		cell.setCellStyle(csBold);
		
		cell = row.createCell(7);
		cell.setCellValue("Drawing Number");
		cell.setCellStyle(csBold);
		
		cell = row.createCell(8);
		cell.setCellValue("Produced Quantity");
		cell.setCellStyle(csBold);
		
		if("Interval".equalsIgnoreCase(flag))
		{
			cell = row.createCell(9);
			cell.setCellValue("Remaining Quantity");
			cell.setCellStyle(csBold);
			
			cell = row.createCell(10);
			cell.setCellValue("Percentage Reached");
			cell.setCellStyle(csBold);
		}else
		{
			cell = row.createCell(9);
			cell.setCellValue("Life Percentage");
			cell.setCellStyle(csBold);
		}
		
	
	}
	private void writeProductReportBook(ProductReport product, Row row, String flag) {
		Cell cell = row.createCell(1);
		cell.setCellValue(product.getProductName());

		cell = row.createCell(2);
		cell.setCellValue(product.getMachine());
		
		cell = row.createCell(3);
		cell.setCellValue(product.getTypeOfTool());
		
		cell = row.createCell(4);
		cell.setCellValue(product.getLotNumber());

		cell = row.createCell(5);
		cell.setCellValue(product.getToolingLife());
		
		cell = row.createCell(6);
		cell.setCellValue(product.getServiceIntervalQty());
		
		cell = row.createCell(7);
		cell.setCellValue(product.getDrawingNumber());
		
		cell = row.createCell(8);
		cell.setCellValue(product.getProducedQty());
		
		if("Interval".equalsIgnoreCase(flag))
		{
			cell = row.createCell(9);
			cell.setCellValue(product.getBalanceProducedQty());
			
			cell = row.createCell(10);
			cell.setCellValue(product.getProducedQtyPercentage());
		}
		else
		{
			cell = row.createCell(9);
			cell.setCellValue(product.getLifePercentage());
		}
		
	}

	public void writeExcel(List<Book> listBook, String excelFilePath) throws IOException {
		Workbook workbook = getWorkbook(excelFilePath);
		Sheet sheet = workbook.createSheet();
		
		int rowCount = 0;
		
		for (Book aBook : listBook) {
			Row row = sheet.createRow(++rowCount);
			writeBook(aBook, row);
		}
		
		try (FileOutputStream outputStream = new FileOutputStream(excelFilePath)) {
			workbook.write(outputStream);
		}		
	}
	
	private void writeBook(Book aBook, Row row) {
		Cell cell = row.createCell(1);
		cell.setCellValue(aBook.getTitle());

		cell = row.createCell(2);
		cell.setCellValue(aBook.getAuthor());
		
		cell = row.createCell(3);
		cell.setCellValue(aBook.getPrice());
	}
	
	private List<Book> getListBook() {
		Book book1 = new Book("Head First Java", "Kathy Serria", 79);
		Book book2 = new Book("Effective Java", "Joshua Bloch", 36);
		Book book3 = new Book("Clean Code", "Robert Martin", 42);
		Book book4 = new Book("Thinking in Java", "Bruce Eckel", 35);
		
		List<Book> listBook = Arrays.asList(book1, book2, book3, book4);
		
		return listBook;
	}
	
	private Workbook getWorkbook(String excelFilePath) 
			throws IOException {
		Workbook workbook = null;
		
		if (excelFilePath.endsWith("xlsx")) {
			workbook = new XSSFWorkbook();
		} else if (excelFilePath.endsWith("xls")) {
			workbook = new HSSFWorkbook();
		} else {
			throw new IllegalArgumentException("The specified file is not Excel file");
		}
		
		return workbook;
	}

	private void setCellStyles(Workbook wb) {

		  //font size 10
		  Font f = wb.createFont();
		  f.setFontHeightInPoints((short) 10);

		  //Simple style 
		  cs = wb.createCellStyle();
		  cs.setFont(f);

		  //Bold Fond
		  Font bold = wb.createFont();
		  bold.setBoldweight(Font.BOLDWEIGHT_BOLD);
		  bold.setFontHeightInPoints((short) 10);

		  //Bold style 
		  csBold = wb.createCellStyle();
		  csBold.setBorderBottom(CellStyle.BORDER_THIN);
		  csBold.setBottomBorderColor(IndexedColors.BLACK.getIndex());
		  csBold.setFont(bold);

		  //Setup style for Top Border Line
		  csTop = wb.createCellStyle();
		  csTop.setBorderTop(CellStyle.BORDER_THIN);
		  csTop.setTopBorderColor(IndexedColors.BLACK.getIndex());
		  csTop.setFont(f);

		  //Setup style for Right Border Line
		  csRight = wb.createCellStyle();
		  csRight.setBorderRight(CellStyle.BORDER_THIN);
		  csRight.setRightBorderColor(IndexedColors.BLACK.getIndex());
		  csRight.setFont(f);

		  //Setup style for Bottom Border Line
		  csBottom = wb.createCellStyle();
		  csBottom.setBorderBottom(CellStyle.BORDER_THIN);
		  csBottom.setBottomBorderColor(IndexedColors.BLACK.getIndex());
		  csBottom.setFont(f);

		  //Setup style for Left Border Line
		  csLeft = wb.createCellStyle();
		  csLeft.setBorderLeft(CellStyle.BORDER_THIN);
		  csLeft.setLeftBorderColor(IndexedColors.BLACK.getIndex());
		  csLeft.setFont(f);

		  //Setup style for Top/Left corner cell Border Lines
		  csTopLeft = wb.createCellStyle();
		  csTopLeft.setBorderTop(CellStyle.BORDER_THIN);
		  csTopLeft.setTopBorderColor(IndexedColors.BLACK.getIndex());
		  csTopLeft.setBorderLeft(CellStyle.BORDER_THIN);
		  csTopLeft.setLeftBorderColor(IndexedColors.BLACK.getIndex());
		  csTopLeft.setFont(f);

		  //Setup style for Top/Right corner cell Border Lines
		  csTopRight = wb.createCellStyle();
		  csTopRight.setBorderTop(CellStyle.BORDER_THIN);
		  csTopRight.setTopBorderColor(IndexedColors.BLACK.getIndex());
		  csTopRight.setBorderRight(CellStyle.BORDER_THIN);
		  csTopRight.setRightBorderColor(IndexedColors.BLACK.getIndex());
		  csTopRight.setFont(f);

		  //Setup style for Bottom/Left corner cell Border Lines
		  csBottomLeft = wb.createCellStyle();
		  csBottomLeft.setBorderBottom(CellStyle.BORDER_THIN);
		  csBottomLeft.setBottomBorderColor(IndexedColors.BLACK.getIndex());
		  csBottomLeft.setBorderLeft(CellStyle.BORDER_THIN);
		  csBottomLeft.setLeftBorderColor(IndexedColors.BLACK.getIndex());
		  csBottomLeft.setFont(f);

		  //Setup style for Bottom/Right corner cell Border Lines
		  csBottomRight = wb.createCellStyle();
		  csBottomRight.setBorderBottom(CellStyle.BORDER_THIN);
		  csBottomRight.setBottomBorderColor(IndexedColors.BLACK.getIndex());
		  csBottomRight.setBorderRight(CellStyle.BORDER_THIN);
		  csBottomRight.setRightBorderColor(IndexedColors.BLACK.getIndex());
		  csBottomRight.setFont(f);

		 }
	
	public static void main(String[] args) throws IOException {
		CreateExcelReport excelWriter = new CreateExcelReport();
		List<Book> listBook = excelWriter.getListBook();
		String excelFilePath = "c:/Muniasamy/JavaBooks1.xls";
		excelWriter.writeExcel(listBook, excelFilePath);
		
		excelFilePath = "c:/Muniasamy/JavaBooks2.xlsx";
		excelWriter.writeExcel(listBook, excelFilePath);
	}

}

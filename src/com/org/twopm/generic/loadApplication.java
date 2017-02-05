package com.org.twopm.generic;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;

/**
 * Servlet implementation class loadApplication
 */
@WebServlet("/loadApplication")
public class loadApplication extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	
	public void init(ServletConfig servletConfig) throws ServletException{
		System.out.println("Load applivcation Called");
        //PlanSchedular.scheduleWeeklyReport();
	  }
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public loadApplication() {
        super();
                
    }
}

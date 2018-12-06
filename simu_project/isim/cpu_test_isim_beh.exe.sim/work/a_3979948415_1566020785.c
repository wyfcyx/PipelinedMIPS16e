/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "D:/Tsinghua/Autumn2018/computer/PipelinedMIPS16e/simu_project/pcselector.vhd";
extern char *IEEE_P_3620187407;
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_1605435078_503743352(char *, unsigned char , unsigned char );
unsigned char ieee_p_2592010699_sub_1690584930_503743352(char *, unsigned char );
unsigned char ieee_p_2592010699_sub_2507238156_503743352(char *, unsigned char , unsigned char );
char *ieee_p_3620187407_sub_436279890_3965413181(char *, char *, char *, char *, int );


static void work_a_3979948415_1566020785_p_0(char *t0)
{
    char t10[16];
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    unsigned int t11;
    unsigned int t12;
    char *t13;
    char *t14;
    unsigned char t15;
    unsigned char t16;
    unsigned char t17;
    unsigned char t18;
    unsigned char t19;
    unsigned char t20;
    unsigned char t21;
    char *t22;
    char *t23;
    char *t24;
    unsigned char t25;
    unsigned char t26;

LAB0:    xsi_set_current_line(31, ng0);
    t1 = (t0 + 2312U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)3);
    if (t4 != 0)
        goto LAB2;

LAB4:    xsi_set_current_line(35, ng0);
    t1 = (t0 + 1032U);
    t2 = *((char **)t1);
    t1 = (t0 + 7696U);
    t5 = ieee_p_3620187407_sub_436279890_3965413181(IEEE_P_3620187407, t10, t2, t1, 1);
    t6 = (t10 + 12U);
    t11 = *((unsigned int *)t6);
    t12 = (1U * t11);
    t3 = (16U != t12);
    if (t3 == 1)
        goto LAB5;

LAB6:    t7 = (t0 + 4736);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    t13 = (t9 + 56U);
    t14 = *((char **)t13);
    memcpy(t14, t5, 16U);
    xsi_driver_first_trans_fast_port(t7);
    xsi_set_current_line(36, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t4 = *((unsigned char *)t2);
    t15 = (t4 == (unsigned char)3);
    if (t15 == 1)
        goto LAB10;

LAB11:    t1 = (t0 + 1832U);
    t5 = *((char **)t1);
    t17 = *((unsigned char *)t5);
    t18 = (t17 == (unsigned char)2);
    if (t18 == 1)
        goto LAB13;

LAB14:    t16 = (unsigned char)0;

LAB15:    t3 = t16;

LAB12:    if (t3 != 0)
        goto LAB7;

LAB9:
LAB8:    xsi_set_current_line(39, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t15 = *((unsigned char *)t2);
    t16 = (t15 == (unsigned char)2);
    if (t16 == 1)
        goto LAB22;

LAB23:    t4 = (unsigned char)0;

LAB24:    if (t4 == 1)
        goto LAB19;

LAB20:    t3 = (unsigned char)0;

LAB21:    if (t3 != 0)
        goto LAB16;

LAB18:
LAB17:    xsi_set_current_line(42, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t15 = *((unsigned char *)t2);
    t16 = (t15 == (unsigned char)2);
    if (t16 == 1)
        goto LAB31;

LAB32:    t4 = (unsigned char)0;

LAB33:    if (t4 == 1)
        goto LAB28;

LAB29:    t3 = (unsigned char)0;

LAB30:    if (t3 != 0)
        goto LAB25;

LAB27:
LAB26:    xsi_set_current_line(45, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t15 = *((unsigned char *)t2);
    t16 = (t15 == (unsigned char)2);
    if (t16 == 1)
        goto LAB42;

LAB43:    t4 = (unsigned char)0;

LAB44:    if (t4 == 1)
        goto LAB39;

LAB40:    t3 = (unsigned char)0;

LAB41:    if (t3 != 0)
        goto LAB36;

LAB38:
LAB37:
LAB3:    xsi_set_current_line(50, ng0);
    t1 = (t0 + 1832U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 1512U);
    t5 = *((char **)t1);
    t4 = *((unsigned char *)t5);
    t15 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t4);
    t16 = ieee_p_2592010699_sub_1605435078_503743352(IEEE_P_2592010699, t3, t15);
    t1 = (t0 + 2312U);
    t6 = *((char **)t1);
    t17 = *((unsigned char *)t6);
    t18 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t17);
    t19 = ieee_p_2592010699_sub_1605435078_503743352(IEEE_P_2592010699, t16, t18);
    t1 = (t0 + 1992U);
    t7 = *((char **)t1);
    t20 = *((unsigned char *)t7);
    t21 = ieee_p_2592010699_sub_1605435078_503743352(IEEE_P_2592010699, t19, t20);
    t1 = (t0 + 4800);
    t8 = (t1 + 56U);
    t9 = *((char **)t8);
    t13 = (t9 + 56U);
    t14 = *((char **)t13);
    *((unsigned char *)t14) = t21;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(51, ng0);
    t1 = (t0 + 1832U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t1 = (t0 + 1512U);
    t5 = *((char **)t1);
    t4 = *((unsigned char *)t5);
    t15 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t4);
    t16 = ieee_p_2592010699_sub_1605435078_503743352(IEEE_P_2592010699, t3, t15);
    t1 = (t0 + 2312U);
    t6 = *((char **)t1);
    t17 = *((unsigned char *)t6);
    t18 = ieee_p_2592010699_sub_1690584930_503743352(IEEE_P_2592010699, t17);
    t19 = ieee_p_2592010699_sub_1605435078_503743352(IEEE_P_2592010699, t16, t18);
    t1 = (t0 + 1992U);
    t7 = *((char **)t1);
    t20 = *((unsigned char *)t7);
    t21 = ieee_p_2592010699_sub_1605435078_503743352(IEEE_P_2592010699, t19, t20);
    t1 = (t0 + 1192U);
    t8 = *((char **)t1);
    t25 = *((unsigned char *)t8);
    t26 = ieee_p_2592010699_sub_2507238156_503743352(IEEE_P_2592010699, t21, t25);
    t1 = (t0 + 4864);
    t9 = (t1 + 56U);
    t13 = *((char **)t9);
    t14 = (t13 + 56U);
    t22 = *((char **)t14);
    *((unsigned char *)t22) = t26;
    xsi_driver_first_trans_fast_port(t1);
    t1 = (t0 + 4592);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(32, ng0);
    t1 = (t0 + 2472U);
    t5 = *((char **)t1);
    t1 = (t0 + 4672);
    t6 = (t1 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t5, 16U);
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(33, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t1 = (t0 + 4736);
    t5 = (t1 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    memcpy(t8, t2, 16U);
    xsi_driver_first_trans_fast_port(t1);
    goto LAB3;

LAB5:    xsi_size_not_matching(16U, t12, 0);
    goto LAB6;

LAB7:    xsi_set_current_line(37, ng0);
    t1 = (t0 + 1672U);
    t7 = *((char **)t1);
    t1 = (t0 + 4672);
    t8 = (t1 + 56U);
    t9 = *((char **)t8);
    t13 = (t9 + 56U);
    t14 = *((char **)t13);
    memcpy(t14, t7, 16U);
    xsi_driver_first_trans_fast_port(t1);
    goto LAB8;

LAB10:    t3 = (unsigned char)1;
    goto LAB12;

LAB13:    t1 = (t0 + 1352U);
    t6 = *((char **)t1);
    t19 = *((unsigned char *)t6);
    t20 = (t19 == (unsigned char)3);
    t16 = t20;
    goto LAB15;

LAB16:    xsi_set_current_line(40, ng0);
    t1 = (t0 + 2152U);
    t7 = *((char **)t1);
    t1 = (t0 + 4672);
    t8 = (t1 + 56U);
    t9 = *((char **)t8);
    t13 = (t9 + 56U);
    t14 = *((char **)t13);
    memcpy(t14, t7, 16U);
    xsi_driver_first_trans_fast_port(t1);
    goto LAB17;

LAB19:    t1 = (t0 + 1992U);
    t6 = *((char **)t1);
    t19 = *((unsigned char *)t6);
    t20 = (t19 == (unsigned char)3);
    t3 = t20;
    goto LAB21;

LAB22:    t1 = (t0 + 1832U);
    t5 = *((char **)t1);
    t17 = *((unsigned char *)t5);
    t18 = (t17 == (unsigned char)3);
    t4 = t18;
    goto LAB24;

LAB25:    xsi_set_current_line(43, ng0);
    t1 = (t0 + 1032U);
    t7 = *((char **)t1);
    t1 = (t0 + 7696U);
    t8 = ieee_p_3620187407_sub_436279890_3965413181(IEEE_P_3620187407, t10, t7, t1, 1);
    t9 = (t10 + 12U);
    t11 = *((unsigned int *)t9);
    t12 = (1U * t11);
    t21 = (16U != t12);
    if (t21 == 1)
        goto LAB34;

LAB35:    t13 = (t0 + 4672);
    t14 = (t13 + 56U);
    t22 = *((char **)t14);
    t23 = (t22 + 56U);
    t24 = *((char **)t23);
    memcpy(t24, t8, 16U);
    xsi_driver_first_trans_fast_port(t13);
    goto LAB26;

LAB28:    t1 = (t0 + 1352U);
    t6 = *((char **)t1);
    t19 = *((unsigned char *)t6);
    t20 = (t19 == (unsigned char)2);
    t3 = t20;
    goto LAB30;

LAB31:    t1 = (t0 + 1832U);
    t5 = *((char **)t1);
    t17 = *((unsigned char *)t5);
    t18 = (t17 == (unsigned char)2);
    t4 = t18;
    goto LAB33;

LAB34:    xsi_size_not_matching(16U, t12, 0);
    goto LAB35;

LAB36:    xsi_set_current_line(46, ng0);
    t1 = (t0 + 1032U);
    t7 = *((char **)t1);
    t1 = (t0 + 7696U);
    t8 = ieee_p_3620187407_sub_436279890_3965413181(IEEE_P_3620187407, t10, t7, t1, 1);
    t9 = (t10 + 12U);
    t11 = *((unsigned int *)t9);
    t12 = (1U * t11);
    t21 = (16U != t12);
    if (t21 == 1)
        goto LAB45;

LAB46:    t13 = (t0 + 4672);
    t14 = (t13 + 56U);
    t22 = *((char **)t14);
    t23 = (t22 + 56U);
    t24 = *((char **)t23);
    memcpy(t24, t8, 16U);
    xsi_driver_first_trans_fast_port(t13);
    goto LAB37;

LAB39:    t1 = (t0 + 1992U);
    t6 = *((char **)t1);
    t19 = *((unsigned char *)t6);
    t20 = (t19 == (unsigned char)2);
    t3 = t20;
    goto LAB41;

LAB42:    t1 = (t0 + 1832U);
    t5 = *((char **)t1);
    t17 = *((unsigned char *)t5);
    t18 = (t17 == (unsigned char)3);
    t4 = t18;
    goto LAB44;

LAB45:    xsi_size_not_matching(16U, t12, 0);
    goto LAB46;

}


extern void work_a_3979948415_1566020785_init()
{
	static char *pe[] = {(void *)work_a_3979948415_1566020785_p_0};
	xsi_register_didat("work_a_3979948415_1566020785", "isim/cpu_test_isim_beh.exe.sim/work/a_3979948415_1566020785.didat");
	xsi_register_executes(pe);
}

/*  ========================================================================== *
 * Copyright (c) 2015-2016 秦凡东(Qin Fandong)
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * ========================================================================== *
 * This to get link options for kernel module to syntastic
 * ========================================================================== */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/printk.h>

MODULE_AUTHOR ("Arondight");
MODULE_LICENSE ("GPL");
MODULE_DESCRIPTION ("This to get link options for kernel module to syntastic");

static int __init arondight_kmodule_init (void)
{
  printk (KERN_DEBUG "0xabadcafe: arondight_kmodule_init.\n");
  return 0;
}

static void __exit arondight_kmodule_exit (void)
{
  printk (KERN_DEBUG "0xabadcafe: arondight_kmodule_exit\n");
}

module_init (arondight_kmodule_init);
module_exit (arondight_kmodule_exit);


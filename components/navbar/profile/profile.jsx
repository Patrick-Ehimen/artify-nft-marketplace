import React from "react";
import Image from "next/image";
import { FaUserAlt, FaRegImage, FaUserEdit } from "react-icons/fa";
import { MdHelpCenter } from "react-icons/md";
import { TbDownloadOff, TbDownload } from "react-icons/tb";
import Link from "next/link";

import Style from "./profile.module.css";
import images from "../../../public/img";

export default function Profile() {
  return (
    <div className={Style.profile}>
      <div className={Style.profile_account}>
        <Image
          src={images.user1}
          alt="user profile"
          width={50}
          height={50}
          className={Style.profile_account_img}
        />

        <div className={Style.profile_account_info}>
          <p>Shoaib Bhai</p>
          {/* <small>{currentAccount.slice(0, 18)}..</small> */}
          <small>hkjri674893054bs..</small>
        </div>
      </div>

      <div className={Style.profile_menu}>
        <div className={Style.profile_menu_one}>
          {[
            { icon: FaUserAlt, link: "/my-profile", text: "My Profile" },
            { icon: FaRegImage, link: "/my-items", text: "My Items" },
            { icon: FaUserEdit, link: "/edit-profile", text: "Edit Profile" },
          ].map((item, index) => (
            <div key={index} className={Style.profile_menu_one_item}>
              <item.icon />
              <p>
                <Link href={{ pathname: item.link }}>{item.text}</Link>
              </p>
            </div>
          ))}
        </div>

        <div className={Style.profile_menu_two}>
          {[
            { icon: MdHelpCenter, link: "/contactus", text: "Help" },
            { icon: TbDownload, link: "/disconnect", text: "Disconnect" },
          ].map((item, index) => (
            <div key={index} className={Style.profile_menu_one_item}>
              <item.icon />
              <p>
                <Link href={{ pathname: item.link }}>{item.text}</Link>
              </p>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

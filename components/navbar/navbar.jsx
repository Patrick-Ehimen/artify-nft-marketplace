"use client";

import React, { useState } from "react";

import Image from "next/image";
import Link from "next/link";

import Style from "./navbar.module.css";
import { Discover, HelpCenter, Notification, Profile, SideBar } from "./index";
import { Button } from "../components-index";
import images from "../../public/img";

import { MdNotifications } from "react-icons/md";
import { BsSearch } from "react-icons/bs";
import { CgMenuLeft, CgMenuRight } from "react-icons/cg";
import { DiJqueryLogo } from "react-icons/di";

const openMenu = (e) => {
  const btnText = e.target.innerText;
  setDiscover(btnText === "Discover");
  setHelp(btnText === "Help Center");
  setNotification(false);
  setProfile(false);
};

const openNotification = () => {
  if (!notification) {
    setNotification(true);
    setDiscover(false);
    setHelp(false);
    setProfile(false);
  } else {
    setNotification(false);
  }
};

export default function Navbar() {
  const [discover, setDiscover] = useState(false);
  const [help, setHelp] = useState(false);
  const [notification, setNotification] = useState(false);
  const [profile, setProfile] = useState(false);
  const [openSideMenu, setOpenSideMenu] = useState(false);

  return (
    <div className={Style.navbar}>
      <div className={Style.navbar_container}>
        <div className={Style.navbar_container_left}>
          <div className={Style.logo}>
            <Image src={images.logo} alt="logo" width={100} height={100} />
          </div>
          <div className={Style.navbar_container_left_box_input}>
            <div className={Style.navbar_container_left_box_input_box}>
              <input type="text" placeholder="Search NFT" />
              <BsSearch onClick={() => {}} className={Style.search_icon} />
            </div>
          </div>
        </div>

        <div className={Style.navbar_container_right}>
          <div className={Style.navbar_container_right_discover}>
            <p onClick={(e) => openMenu(e)}>Discover</p>
            {discover && (
              <div className={Style.navbar_container_right_discover_box}>
                <Discover />
              </div>
            )}
          </div>

          <div className={Style.navbar_container_right_help}>
            <p onClick={(e) => openMenu(e)}>Help Center</p>
            {/* {help && ( */}
            <div className={Style.navbar_container_right_help_box}>
              <HelpCenter />
            </div>
          </div>

          <div className={Style.navbar_container_right_notify}>
            <MdNotifications
              className={Style.notify}
              onClick={() => openNotification()}
            />
            {notification && <Notification />}
          </div>

          {/* CREATE BUTTON SECTION */}
          {/* <div className={Style.navbar_container_right_button}>
            {currentAccount == "" ? (
              <Button btnName="Connect" handleClick={() => connectWallet()} />
            ) : (
              <Button
                btnName="Create"
                handleClick={() => router.push("/uploadNFT")}
              />
            )}
          </div> */}
        </div>
      </div>
    </div>
  );
}

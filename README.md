<a id="readme-top"></a>

<div align="center">

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GPL-3.0 License][license-shield]][license-url]

</div>

<br />

<div align="center">
  <a href="https://github.com/iuu6/nix-config">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>
  <h3 align="center">Nix-Config</h3>
  <p align="center">
    This is my Nix-Config, which I want to be able to adapt to all kinds of software and make it easy to configure any computer.
    <br />
    <a href="https://github.com/iuu6/nix-config"><strong>Start >></strong></a>
    <br />
    <br />
    <a href="https://github.dev/iuu6/nix-config">Quick Edit</a>
    ·
    <a href="https://github.com/iuu6/nix-config/issues">Report an error/suggest more content</a>
    ·
    <a href="#">More...</a>
  </p>

</div>




<details>
  <summary>Project Catalog</summary>
  <ol>
    <li>
      <a href="#About this program">About this program</a>
      <ul>
        <li><a href="#Built by whom">Built by whom</a></li>
      </ul>
    </li>
    <li>
      <a href="#Quick Start">Quick Start</a>
      <ul>
        <li><a href="#Prerequisites">Prerequisites</a></li>
        <li><a href="#Install">Install</a></li>
      </ul>
    </li>
    <li><a href="#Usage">Usage</a></li>
    <li><a href="#Functional Routes">Functional Routes</a></li>
  </ol>
</details>



# About this program

![Nix-Config][product-screenshot]

Nix is a tool that takes a unique approach to package management and system configuration. 

I don't recommend NixOS for people who don't like to fiddle around, because unlike most Linux distributions, the immutability of NixOS can make your head spin.

If you love Linux, you are welcome to use NixOS to enjoy immutability.

I hope this project will help you get started with NixOS quickly and give you a reference quick start program.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Built by whom

This profile is built using flake and depends on the NixOS system.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

# Quick Start

## Prerequisites

You may need a computer with the NixOS distribution.

## Install

You can put the configuration file into `/etc/nixos` and use it directly, but be aware that you may need to be careful about modifying the contents of it as well as the disk configuration file, or you may be in big trouble.

But it doesn't matter, even if the shit hits the fan, you can roll back immediately because this is an excellent feature of NixOS.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

# Usage

## Core Configuration

`. /flake.nix` is where the whole project is introduced, you only need to modify this file to change the introduction about your computer. Please take care to match the name of your computer as well as determine the environment you want to avoid non-essential hassles.

## Desktop Environment

The desktop environment can be accessed directly through the `. /desktop-env`. The desktop environments you need to use are in `. /desktop-env/common` in `. /desktop-env/default.nix`. For your convenience, there are a number of desktop environment options available.

## Program Environment

The Program Environment is similar to the Desktop Environment, so use it as you see fit.

## Others

Stay tuned for more features!

<p align="right">(<a href="#readme-top">back to top</a>)</p>

# Functional Routes

- [x] Flake Multi-Device Management

- [x] Desktop Environment

- [ ] Program Environment

- [ ] Fixing cluttered configuration files for structure

<p align="right">(<a href="#readme-top">back to top</a>)</p>



[contributors-shield]: https://img.shields.io/github/contributors/iuu6/nix-config.svg?style=for-the-badge
[contributors-url]: https://github.com/iuu6/nix-config/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/iuu6/nix-config.svg?style=for-the-badge
[forks-url]: https://github.com/iuu6/nix-config/network/members
[stars-shield]: https://img.shields.io/github/stars/iuu6/nix-config.svg?style=for-the-badge
[stars-url]: https://github.com/iuu6/nix-config/stargazers
[issues-shield]: https://img.shields.io/github/issues/iuu6/nix-config.svg?style=for-the-badge
[issues-url]: https://github.com/iuu6/nix-config/issues
[license-shield]: https://img.shields.io/github/license/iuu6/nix-config.svg?style=for-the-badge
[license-url]: https://github.com/iuu6/nix-config/blob/master/LICENSE
[product-screenshot]: images/screenshot.png